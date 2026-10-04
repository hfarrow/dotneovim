"""Sequential attached-grid wall-clock profiling; no runtime dependencies.

Use the existing test venv with Msgpack. Output is raw JSON, including samples.
"""
import argparse
import hashlib
import json
import math
import os
import pathlib
import select
import statistics
import subprocess
import tempfile
import time
import msgpack

ROOT = pathlib.Path(__file__).resolve().parents[1]
BASE = pathlib.Path(os.environ['DOTNEOVIM_TEST_HOME'])
ENV = dict(os.environ, **{f'XDG_{k}_HOME': str(BASE / k.lower()) for k in ['CONFIG', 'DATA', 'STATE', 'CACHE']})


class Probe:
    def __init__(self, args=(), config=None, env=None, reference=None):
        self.started = time.perf_counter_ns()
        marker = "lua vim.g.perf_start=vim.uv.hrtime(); vim.api.nvim_create_autocmd('VimEnter',{once=true,callback=function() vim.g.perf_enter=(vim.uv.hrtime()-vim.g.perf_start)/1e6 end})"
        command = ['nvim', '--embed', '-i', 'NONE', '--cmd', marker]
        if reference:
            command += ['--cmd', 'set rtp^=' + str(reference)]
        command += ['-u', str(config or ROOT / 'init.lua'), *args]
        self.p = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=env or ENV)
        self.unpack = msgpack.Unpacker(raw=False)
        self.serial = 0
        self.responses = {}
        self.grids = {}
        self.flush = 0
        self.errors = []
        self.stderr = b''
        self.send('nvim_ui_attach', 160, 50, {'rgb': True, 'ext_linegrid': True})

    def send(self, method, *args):
        self.serial += 1
        self.p.stdin.write(msgpack.packb([0, self.serial, method, args]))
        self.p.stdin.flush()
        return self.serial

    def pump(self):
        readable = select.select([self.p.stdout, self.p.stderr], [], [], .1)[0]
        if self.p.stderr in readable:
            self.stderr += os.read(self.p.stderr.fileno(), 65536)
        if self.p.stdout in readable:
            data = os.read(self.p.stdout.fileno(), 1048576)
            assert data, self.stderr.decode()
            self.unpack.feed(data)
        for message in self.unpack:
            if message[0] == 1:
                assert message[2] is None, message[2]
                self.responses[message[1]] = message[3]
            if message[0] == 2 and message[1] == 'redraw':
                for event in message[2]:
                    name = event[0]
                    for item in event[1:]:
                        if name == 'grid_resize':
                            grid, width, height = item
                            self.grids[grid] = [[' '] * width for _ in range(height)]
                        elif name == 'grid_clear':
                            for row in self.grids[item[0]]:
                                row[:] = [' '] * len(row)
                        elif name == 'grid_line':
                            grid, row, col, cells = item[:4]
                            target = self.grids[grid][row]
                            for cell in cells:
                                for _ in range(cell[2] if len(cell) > 2 else 1):
                                    if col < len(target):
                                        target[col] = cell[0]
                                    col += 1
                        elif name == 'grid_scroll':
                            grid, top, bottom, left, right, rows, cols = item
                            old = [r[:] for r in self.grids[grid]]
                            for row in range(top, bottom):
                                for col in range(left, right):
                                    src_r, src_c = row + rows, col + cols
                                    self.grids[grid][row][col] = old[src_r][src_c] if top <= src_r < bottom and left <= src_c < right else ' '
                        elif name == 'flush':
                            self.flush += 1

    def text(self):
        return '\n'.join(''.join(row) for grid in self.grids.values() for row in grid)

    def until(self, predicate, timeout=10):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            if predicate():
                return time.perf_counter_ns()
            self.pump()
        raise AssertionError('Readiness timeout: ' + self.text()[-3000:] + self.stderr.decode())

    def lua(self, code):
        ident = self.send('nvim_exec_lua', code, [])
        self.until(lambda: ident in self.responses)
        return self.responses.pop(ident)

    def close(self):
        self.send('nvim_command', 'qa!')
        assert self.p.wait(timeout=10) == 0, self.stderr.decode()
        return (time.perf_counter_ns() - self.started) / 1e6


def summary(samples):
    def dist(values):
        ordered = sorted(values)
        return {'median': statistics.median(values), 'p95': ordered[math.ceil(.95 * len(values)) - 1]}
    return {'count': len(samples), 'summary_ms': {key: dist([s[key] for s in samples]) for key in samples[0] if isinstance(samples[0][key], (float, int))}, 'samples': samples}


def launch(args, target, config=None, env=None, reference=None, dashboard=False):
    probe = Probe(args, config, env, reference)
    try:
        stamp = probe.until(lambda: probe.flush > 0 and target in probe.text()
                            and (not dashboard or 'Files[f]' in probe.text())
                            and (config == 'NONE' or reference or dashboard or pathlib.Path(args[0]).name in probe.text()))
        ready = (stamp - probe.started) / 1e6
        values = probe.lua("return {enter=vim.g.perf_enter,error=vim.v.errmsg,ft=vim.bo.filetype}")
        assert values['error'] == '', values
        if config != 'NONE' and not reference and dashboard:
            assert values['ft'] == 'dashboard', values
        return {'redraw_ms': ready, 'vimenter_ms': values.get('enter', 0), 'lifetime_ms': probe.close()}
    except Exception:
        if probe.p.poll() is None:
            probe.p.kill()
            probe.p.wait()
        raise


def first_action(fixture, action):
    probe = Probe((str(fixture / 'fixture.txt'),))
    try:
        probe.until(lambda: probe.flush > 0 and 'PROFILE_TEXT' in probe.text())
        probe.lua("return vim.v.vim_did_enter")
        probe.lua('vim.cmd.cd(' + json.dumps(str(fixture)) + '); return true')
        # Let asynchronous setup settle; action plugin itself is still unloaded.
        time.sleep(.1)
        if action == 'completion':
            probe.lua("vim.api.nvim_buf_set_lines(0,0,-1,false,{'uniqueword',''}); vim.api.nvim_win_set_cursor(0,{2,0}); return true")
        elif action == 'terminal':
            probe.lua("vim.o.shell='/bin/sh'; return true")
        initial = probe.flush
        start = time.perf_counter_ns()
        keys = {'tree': ' e', 'picker': " '", 'completion': 'iun', 'terminal': ' th'}[action]
        probe.send('nvim_input', keys)
        if action == 'terminal':
            probe.until(lambda: probe.flush > initial and '$' in probe.text())
            probe.send('nvim_input', "printf 'PROFILE_SHELL_READY\\n'<CR>")
            # Shell echo alone is not readiness; the rendered output has its own line.
            stamp = probe.until(lambda: any(''.join(r).strip() == 'PROFILE_SHELL_READY' for g in probe.grids.values() for r in g))
        else:
            marker = {'tree': 'fixture.md', 'picker': 'Results', 'completion': 'uniqueword'}[action]
            stamp = probe.until(lambda: probe.flush > initial and marker in probe.text() and (action != 'completion' or probe.text().count('uniqueword') >= 2))
            if action == 'tree': assert probe.lua('return vim.bo.filetype') == 'NvimTree'
            if action == 'picker':
                assert probe.lua('return vim.bo.filetype') == 'TelescopePrompt'
                probe.until(lambda: 'fixture.txt' in probe.text())
                stamp = time.perf_counter_ns()
            if action == 'completion': assert probe.lua("return require('blink.cmp').is_visible() and require('blink.cmp').get_selected_item()==nil")
        latency = (stamp - start) / 1e6
        assert probe.lua('return vim.v.errmsg') == ''
        probe.close()
        return {'ready_ms': latency}
    finally:
        if probe.p.poll() is None:
            probe.p.kill()
            probe.p.wait()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--samples', type=int, default=10)
    parser.add_argument('--output', required=True)
    parser.add_argument('--reference', type=pathlib.Path)
    parser.add_argument('--first-use', action='store_true')
    parser.add_argument('--enforce-budgets', action='store_true')
    opts = parser.parse_args()
    assert opts.samples >= 10
    results = {'environment': {'nvim': subprocess.check_output(['nvim', '--version'], text=True).splitlines()[0],
                              'machine': subprocess.check_output(['sysctl', '-n', 'machdep.cpu.brand_string'], text=True).strip(),
                              'os': subprocess.check_output(['sw_vers', '-productVersion'], text=True).strip(),
                              'revision': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
                              'lock_sha256': hashlib.sha256((ROOT / 'lazy-lock.json').read_bytes()).hexdigest()},
               'startup': {}, 'empty_editor_cache': {}, 'minimal': {}, 'first_use': {}, 'original': {}}
    with tempfile.TemporaryDirectory(prefix='dotneovim profile ') as temp:
        fixture = pathlib.Path(temp)
        (fixture / 'fixture.txt').write_text('PROFILE_TEXT reading fixture\nsecond line\n')
        (fixture / 'fixture.lua').write_text('local PROFILE_CODE = 1\nprint(PROFILE_CODE)\n')
        (fixture / 'fixture.md').write_text('# PROFILE_MARKDOWN\n\n**Readable prose**, `code`, and a list.\n\n- first\n- second\n')
        cases = {'empty': ((), '███', True), 'directory': ((str(fixture),), '███', True),
                 'dashboard': (('-c', 'Dashboard'), '███', True), 'text': ((str(fixture / 'fixture.txt'),), 'PROFILE_TEXT', False),
                 'code': ((str(fixture / 'fixture.lua'),), 'PROFILE_CODE', False), 'markdown': ((str(fixture / 'fixture.md'),), 'PROFILE_MARKDOWN', False)}
        for name, (args, marker, dashboard) in cases.items():
            cache_env = dict(ENV, XDG_CACHE_HOME=str(fixture / ('cache-' + name)))
            results['empty_editor_cache'][name] = launch(args, marker, env=cache_env, dashboard=dashboard)
            launch(args, marker, dashboard=dashboard)
            results['startup'][name] = summary([launch(args, marker, dashboard=dashboard) for _ in range(opts.samples)])
            minimal_args = () if dashboard else args
            target = '' if dashboard else marker
            results['minimal'][name] = summary([launch(minimal_args, target, config='NONE') for _ in range(opts.samples)])
            if opts.reference:
                ref_env = dict(os.environ, XDG_CONFIG_HOME=str(BASE / 'config'), XDG_STATE_HOME=str(fixture / 'ref-state'), XDG_CACHE_HOME=str(fixture / 'ref-cache'))
                # Original data contains its Packer packages. Never provision/update it.
                try:
                    ref_args = () if dashboard else args
                    results['original'][name] = summary([launch(ref_args, 'NEOVIM' if dashboard else marker, config=opts.reference / 'init.lua', env=ref_env, reference=opts.reference) for _ in range(opts.samples)])
                except Exception as error:
                    results['original'][name] = {'error': str(error)}
        if opts.first_use:
            for action in ('tree', 'picker', 'completion', 'terminal'):
                pathlib.Path(opts.output).write_text(json.dumps(results, indent=2))
                results['first_use'][action] = summary([first_action(fixture, action) for _ in range(opts.samples)])
    pathlib.Path(opts.output).write_text(json.dumps(results, indent=2))
    if opts.enforce_budgets:
        for name, value in results['startup'].items():
            budget = 150 if name in ('empty', 'directory', 'dashboard') else 100
            assert value['summary_ms']['redraw_ms']['median'] <= budget, (name, budget, value['summary_ms'])
    print(json.dumps({section: {name: value.get('summary_ms', value) for name, value in results[section].items()} for section in ('startup', 'empty_editor_cache', 'minimal', 'first_use', 'original')}, indent=2))
