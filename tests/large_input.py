"""Actual attached redraw/motion/search/reload for excluded large inputs."""
import json
import pathlib
import tempfile
import time
from performance import Probe, BASE

results = {}
with tempfile.TemporaryDirectory(prefix='dotneovim large ') as directory:
    directory = pathlib.Path(directory)
    cases = {'large.log': ''.join('log row %06d data value\n' % i for i in range(400000)),
             'many.lua': 'x=1\n' * 120000, 'minified.js': 'const value="' + 'x' * 250000 + '";\n'}
    for name, content in cases.items():
        path = directory / name
        content += 'PROFILE_END\n'
        path.write_text(content)
        probe = Probe((str(path),))
        try:
            stamp = probe.until(lambda: probe.flush > 0 and name in probe.text(), timeout=10)
            startup = (stamp - probe.started) / 1e6
            state = probe.lua("return {large=vim.b.dotneovim_large,ts=vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]~=nil, clients=#vim.lsp.get_clients({bufnr=0}),syntax=vim.bo.syntax}")
            assert state['large'] and not state['ts'] and state['clients'] == 0 and state['syntax'] == 'OFF', (name, state)
            initial = probe.flush
            start = time.perf_counter_ns()
            probe.send('nvim_input', 'G')
            end = probe.until(lambda: probe.flush > initial and 'PROFILE_END' in probe.text())
            motion = (end - start) / 1e6
            probe.lua("vim.api.nvim_win_set_cursor(0,{1,0}); vim.cmd('redraw'); return true")
            probe.lua('return vim.api.nvim_win_get_cursor(0)[1]')
            initial = probe.flush
            start = time.perf_counter_ns()
            probe.send('nvim_input', '/PROFILE_END<CR>')
            probe.lua('return vim.api.nvim_get_mode().mode')
            end = probe.until(lambda: probe.flush > initial and 'PROFILE_END' in probe.text())
            assert probe.lua('return vim.api.nvim_win_get_cursor(0)[1]') == len(content.splitlines())
            search = (end - start) / 1e6
            path.write_text(content + 'PROFILE_RELOADED\n')
            start = time.perf_counter_ns()
            probe.lua("vim.api.nvim_exec_autocmds('FocusGained',{}); return true")
            assert probe.lua("return vim.api.nvim_buf_get_lines(0,-2,-1,false)[1]") == 'PROFILE_RELOADED'
            reload = (time.perf_counter_ns() - start) / 1e6
            assert probe.lua("return require('config.largefile').check(0) and #vim.lsp.get_clients({bufnr=0})==0 and not require('blink.cmp.config').enabled()")
            initial = probe.flush
            probe.send('nvim_input', 'i(')
            probe.until(lambda: probe.flush > initial and '-- INSERT --' in probe.text())
            assert probe.lua("return vim.api.nvim_get_current_line():sub(1,2)") == '(P', 'Automatic pairing excluded'
            assert not probe.lua("return require('blink.cmp').is_visible()"), 'Completion excluded'
            probe.send('nvim_input', '<Esc>')
            assert probe.lua("return not require('rainbow-delimiters').is_enabled(0)")
            assert probe.lua('return vim.v.errmsg') == ''
            # Conservative bounds for actual operations, not a startup median budget.
            assert max(motion, search, reload) < 1000, (name, motion, search, reload)
            results[name] = {'bytes': len(content.encode()), 'lines': len(content.splitlines()), 'startup_ms': startup,
                             'motion_ms': motion, 'search_ms': search, 'reload_ms': reload, 'exclusions': state}
            probe.close()
        finally:
            if probe.p.poll() is None:
                probe.p.kill()
                probe.p.wait()
    probe = Probe((str(directory / 'small.txt'),))
    try:
        probe.until(lambda: probe.flush > 0)
        assert probe.lua("vim.cmd.enew(); vim.api.nvim_buf_set_lines(0,0,-1,false,{'small'}); return not require('config.largefile').check(0)")
        assert probe.lua("vim.api.nvim_buf_set_lines(0,0,-1,false,{string.rep('x',10001)}); return require('config.largefile').check(0)")
        results['changedtick_invalidation'] = True
        probe.close()
    finally:
        if probe.p.poll() is None:
            probe.p.kill()
            probe.p.wait()
(BASE / 'large-input-results.json').write_text(json.dumps(results, indent=2))
print(json.dumps(results, indent=2))
