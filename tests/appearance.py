"""Actual cmux/Ghostty acceptance. Requires explicit temporary OS-switch consent.

DOTNEOVIM_APPEARANCE_TEST=1, DOTNEOVIM_TEST_HOME and authorized screen capture.
Restores original system dark/automatic values and selected workspace in finally.
Never edits terminal configuration files or another surface's contents.
"""
import hashlib
import json
import os
import pathlib
import shlex
import subprocess
import time

ROOT = pathlib.Path(__file__).resolve().parents[1]
BASE = pathlib.Path(os.environ['DOTNEOVIM_TEST_HOME'])
CMUX = '/Applications/cmux.app/Contents/Resources/bin/cmux'
assert os.environ.get('DOTNEOVIM_APPEARANCE_TEST') == '1', 'Explicit appearance test consent required'


def run(args, **kwargs):
    return subprocess.check_output(args, text=True, timeout=20, **kwargs).strip()


def default(key):
    value = subprocess.run(['defaults', 'read', '-g', key], capture_output=True, text=True)
    return value.stdout.strip() if value.returncode == 0 else None


def dark():
    return run(['osascript', '-e', 'tell application "System Events" to tell appearance preferences to get dark mode']) == 'true'


def switch(mode):
    run(['osascript', '-e', 'tell application "System Events" to tell appearance preferences to set dark mode to ' + ('true' if mode == 'dark' else 'false')])
    time.sleep(1)


def rpc(code):
    return json.loads(run(['nvim', '--server', str(BASE / 'host.sock'), '--remote-expr',
                           'luaeval(' + json.dumps('vim.json.encode((function() ' + code + ' end)())') + ')'], stderr=subprocess.PIPE))


def wait(mode):
    for _ in range(60):
        try:
            result = rpc("return {background=vim.o.background, normal=vim.api.nvim_get_hl(0,{name='Normal',link=false}), error=vim.v.errmsg}")
            if result['background'] == mode:
                colors = {'light': (0xfbf1c7, 0x654735), 'dark': (0x282828, 0xd4be98)}[mode]
                assert (result['normal']['bg'], result['normal']['fg']) == colors, result
                assert result['error'] == '', result
                return result
        except subprocess.CalledProcessError:
            pass
        time.sleep(.1)
    raise AssertionError('Actual host did not report ' + mode)


def snapshot(label):
    report = rpc("local h={}; for _,name in ipairs({'Normal','TelescopeNormal','NvimTreeNormal','lualine_a_normal','RenderMarkdownH1Bg'}) do h[name]=vim.api.nvim_get_hl(0,{name=name,link=false}) end; return {background=vim.o.background, highlights=h, responses=vim.g.appearance_responses or {}}")
    terminals = json.loads(run([CMUX, 'rpc', 'debug.terminals', '{}']))['terminals']
    terminal = next(t for t in terminals if t['workspace_ref'] == workspace)
    image = BASE / ('appearance-' + label + '.png')
    run(['screencapture', '-x', '-l', str(terminal['window_number']), str(image)])
    return {'state': report, 'screenshot': str(image)}


original_dark = dark()
original_keys = {key: default(key) for key in ('AppleInterfaceStyle', 'AppleInterfaceStyleSwitchesAutomatically')}
original_workspace = run([CMUX, 'current-workspace'])
ghostty = pathlib.Path.home() / '.config/ghostty/config'
config_digest = hashlib.sha256(ghostty.read_bytes()).hexdigest()
workspace = None
results = {}
try:
    switch('dark')
    response = run([CMUX, 'new-workspace', '--name', 'dotneovim-appearance-acceptance', '--cwd', str(ROOT), '--focus', 'true'])
    workspace = response.split()[-1]
    surfaces = run([CMUX, 'list-pane-surfaces', '--workspace', workspace])
    surface = next(s.strip('* ').split()[0] for s in surfaces.splitlines() if 'surface:' in s)
    env = ' '.join(shlex.quote('XDG_' + name + '_HOME=' + str(BASE / name.lower())) for name in ('CONFIG', 'DATA', 'STATE', 'CACHE'))
    command = env + ' nvim --listen ' + shlex.quote(str(BASE / 'host.sock')) + ' -u ' + shlex.quote(str(ROOT / 'init.lua'))
    run([CMUX, 'send', '--workspace', workspace, '--surface', surface, command + '\n'])
    results['dark_startup'] = wait('dark')
    rpc("vim.g.appearance_responses={}; vim.api.nvim_create_autocmd('TermResponse',{callback=function(ev) local r=vim.g.appearance_responses; r[#r+1]=ev.data.sequence; vim.g.appearance_responses=r end}); return true")
    # Capture the actual dashboard and glyphs, then load each derived UI owner.
    results['dark_dashboard'] = snapshot('dark-dashboard')
    rpc("vim.cmd('NvimTreeOpen'); require('config.search').open('files','normal'); return true")
    time.sleep(.5)
    results['dark_picker'] = snapshot('dark-picker')
    rpc("require('telescope.actions').close(vim.api.nvim_get_current_buf()); vim.cmd.edit(vim.g.dotneovim_root..'/README.md'); return true")
    time.sleep(.5)
    results['dark_markdown_tree'] = snapshot('dark-markdown-tree')
    for mode in ('light', 'dark', 'light'):
        switch(mode)
        wait(mode)
        results['live_' + mode + '_' + str(len(results))] = snapshot(mode + '-live-' + str(len(results)))
    variants = [entry['state'] for key, entry in results.items() if key.startswith('live_')]
    for name in ('TelescopeNormal', 'NvimTreeNormal', 'lualine_a_normal', 'RenderMarkdownH1Bg'):
        assert variants[0]['highlights'][name] != variants[1]['highlights'][name], name + ' variant refresh'
        assert variants[0]['highlights'][name] == variants[2]['highlights'][name], name + ' light restoration'
    assert any('997;' in response or ']11;' in response for response in variants[-1]['responses']), 'Actual host appearance reports'
    # Fresh light startup, rather than equating a live change with startup.
    run([CMUX, 'send', '--workspace', workspace, '--surface', surface, ':qa!\n'])
    time.sleep(.5)
    run([CMUX, 'send', '--workspace', workspace, '--surface', surface, command + '\n'])
    results['light_startup'] = wait('light')
    results['light_dashboard'] = snapshot('light-dashboard')
finally:
    try:
        if workspace:
            run([CMUX, 'send-key', '--workspace', workspace, '--surface', surface, 'escape'])
            run([CMUX, 'send', '--workspace', workspace, '--surface', surface, ':qa!\n'])
            time.sleep(.3)
            run([CMUX, 'close-workspace', '--workspace', workspace])
        run([CMUX, 'select-workspace', '--workspace', original_workspace])
    finally:
        switch('dark' if original_dark else 'light')
        for key, value in original_keys.items():
            if value is None:
                subprocess.run(['defaults', 'delete', '-g', key], capture_output=True)
            elif key == 'AppleInterfaceStyleSwitchesAutomatically':
                run(['defaults', 'write', '-g', key, '-bool', 'true' if value in ('1', 'true') else 'false'])
            else:
                run(['defaults', 'write', '-g', key, '-string', value])
        assert dark() == original_dark
        assert {key: default(key) for key in original_keys} == original_keys
        assert hashlib.sha256(ghostty.read_bytes()).hexdigest() == config_digest
        assert run([CMUX, 'current-workspace']) == original_workspace
        results['restoration'] = {'dark': original_dark, 'keys': original_keys, 'workspace': original_workspace, 'terminal_config_unchanged': True}
        (BASE / 'appearance-results.json').write_text(json.dumps(results, indent=2))
print(json.dumps(results, indent=2))
