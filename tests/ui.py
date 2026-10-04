"""Real attached UI and RPC input. Requires msgpack in an isolated test venv."""
import os
import pathlib
import subprocess
import tempfile
import time
from ui_client import Editor, ENV, ROOT


with tempfile.TemporaryDirectory(prefix='dotneovim ui space ') as fixture:
    one = pathlib.Path(fixture) / 'one.txt'
    two = pathlib.Path(fixture) / 'two.txt'
    one.write_text('hello world\n')
    two.write_text('second\n')
    code = pathlib.Path(fixture) / 'fixture.lua'
    markdown = pathlib.Path(fixture) / 'fixture.md'
    code.write_text('local value = 1\nprint(value)\n')
    markdown.write_text('# Reading fixture\n\n**Readable prose** and `code`.\n')
    for args, dashboard in [((), True), ((fixture,), True), ((str(one),), False),
                            ((str(one), str(two)), False), ((fixture + '/COMMIT_EDITMSG',), False),
                            ((str(code),), False), ((str(markdown),), False)]:
        editor = Editor(args)
        editor.wait('return vim.v.vim_did_enter', 1)
        time.sleep(.3)
        assert (editor.lua('return vim.bo.filetype') == 'dashboard') == dashboard, args
        assert editor.lua('return vim.v.errmsg') == '', (args, editor.lua('return vim.v.errmsg'), editor.errors.decode())
        assert any(event[0] == 'grid_line' for event in editor.redraws), 'Attached grid drawn'
        if args == (str(code),):
            assert editor.lua('return vim.bo.filetype') == 'lua'
            assert editor.lua('return vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil')
        if args == (str(markdown),):
            assert editor.lua('return vim.bo.filetype') == 'markdown'
            assert editor.lua('return vim.wo.wrap and vim.wo.spell')
        if dashboard:
            assert editor.lua("return table.concat(vim.api.nvim_buf_get_lines(0,0,-1,false)):find('███') ~= nil")
            editor.call('nvim_input', 'e')
            editor.wait("return vim.bo.filetype == 'NvimTree'")
            editor.call('nvim_input', ' e')
            editor.wait("return vim.bo.filetype == 'dashboard'")
            editor.call('nvim_input', 'f')
            editor.wait("return vim.bo.filetype == 'TelescopePrompt'")
            editor.call('nvim_input', '<C-v>')
            editor.wait("local p=require('telescope.actions.state').get_current_picker(vim.api.nvim_get_current_buf()); return p and p.prompt_title:find('hidden') ~= nil")
            editor.call('nvim_input', '<C-r>')
            editor.wait("local p=require('telescope.actions.state').get_current_picker(vim.api.nvim_get_current_buf()); return p and p.prompt_title:find('project') ~= nil")
        editor.close()
    editor = Editor((str(one),))
    editor.wait('return vim.v.vim_did_enter', 1)
    editor.lua("vim.api.nvim_buf_set_lines(0,0,-1,false,{'start alpha beta zztarget omega'}); vim.api.nvim_win_set_cursor(0,{1,0})")
    editor.call('nvim_input', 'szz')
    editor.wait('return vim.api.nvim_win_get_cursor(0)[2]', 17)
    editor.call('nvim_input', '<Esc>0vszz<Esc>')
    time.sleep(.2)
    assert editor.lua('return vim.api.nvim_win_get_cursor(0)[2]') == 17, 'Visual Leap'
    editor.call('nvim_input', '0dszz')
    time.sleep(.3)
    assert editor.lua("return vim.api.nvim_get_current_line()") in ('zztarget omega', 'ztarget omega'), editor.lua("return vim.api.nvim_get_current_line()")
    editor.close()
    editor = Editor((str(one),))
    editor.wait('return vim.v.vim_did_enter', 1)
    editor.wait("return require('blink.cmp.fuzzy').implementation_type", 'lua' if os.environ.get('DOTNEOVIM_BLINK_LUA') == '1' else 'rust')
    assert 'No fuzzy matching library' not in editor.errors.decode()
    editor.close()
    subprocess.run(['git', '-C', fixture, 'init', '--quiet'], check=True)
    subprocess.run(['git', '-C', fixture, 'add', 'one.txt', 'two.txt'], check=True)
    identity = dict(ENV, GIT_AUTHOR_NAME='Fixture', GIT_AUTHOR_EMAIL='fixture@example.invalid', GIT_COMMITTER_NAME='Fixture', GIT_COMMITTER_EMAIL='fixture@example.invalid')
    subprocess.run(['git', '-C', fixture, 'commit', '--quiet', '-m', 'Fixture'], env=identity, check=True)
    editor = Editor((str(one),))
    editor.wait('return vim.v.vim_did_enter', 1)
    origin = editor.lua('return vim.api.nvim_get_current_win()')
    editor.call('nvim_input', ' th')
    editor.wait("return vim.bo.buftype == 'terminal'")
    editor.call('nvim_input', '<Esc> tv')
    editor.wait("return require('config.terminal').shells.vertical ~= nil and vim.api.nvim_get_current_buf() == require('config.terminal').shells.vertical.bufnr")
    time.sleep(.2)
    assert editor.lua("return require('config.terminal').shells.vertical:is_focused()"), 'Switch layout retains new focus'
    editor.call('nvim_input', '<C-g>')
    editor.wait('return vim.api.nvim_get_current_win()', origin)
    for key, direction in [('th', 'horizontal'), ('tv', 'vertical'), ('tf', 'float')]:
        editor.call('nvim_input', ' ' + key)
        editor.wait("return vim.bo.buftype == 'terminal'")
        editor.wait("return vim.api.nvim_get_mode().mode", 't')
        term = editor.lua(f"local t=require('config.terminal').shells.{direction}; return {{job=t.job_id, buf=t.bufnr, dir=t.dir}}")
        assert os.path.realpath(term['dir']) == os.path.realpath(fixture), 'Shell cwd'
        assert editor.lua('return vim.fn.jobpid(' + str(term['job']) + ')') > 0
        time.sleep(.2)
        editor.call('nvim_input', 'pwd > cwd-result-' + direction + '<CR>')
        deadline = time.monotonic() + 5
        output = pathlib.Path(fixture) / ('cwd-result-' + direction)
        while not output.exists() and time.monotonic() < deadline:
            time.sleep(.05)
        assert output.exists() and os.path.realpath(output.read_text().strip()) == os.path.realpath(fixture), 'Actual shell cwd'
        editor.call('nvim_input', '<Esc>')
        editor.wait("return vim.api.nvim_get_mode().mode", 'nt')
        editor.call('nvim_input', '<C-g>')
        editor.wait('return vim.api.nvim_get_current_win()', origin)
        editor.call('nvim_input', ' ' + key)
        editor.wait("return vim.bo.buftype == 'terminal'")
        assert editor.lua(f"return require('config.terminal').shells.{direction}.job_id") == term['job'], 'Persistent process'
        if direction == 'horizontal':
            editor.call('nvim_input', '<C-k>')
            editor.wait('return vim.api.nvim_get_current_win()', origin)
            editor.call('nvim_input', '<C-j>')
            editor.wait("return vim.bo.buftype == 'terminal'")
        editor.wait("return vim.api.nvim_get_mode().mode", 't')
        editor.call('nvim_input', 'exit<CR>')
        editor.wait('return vim.api.nvim_get_current_win()', origin)
    editor.call('nvim_input', ' lg')
    editor.wait("return require('config.terminal').lazygit ~= nil and vim.bo.buftype == 'terminal'")
    editor.wait("return vim.api.nvim_get_mode().mode", 't')
    gitjob = editor.lua('return require("config.terminal").lazygit.job')
    assert os.path.realpath(editor.lua('return require("config.terminal").lazygit.root')) == os.path.realpath(fixture)
    editor.call('nvim_input', '<C-g>')
    editor.wait('return vim.api.nvim_get_current_win()', origin)
    one.write_text('external changed\nsecond\n')
    editor.call('nvim_input', ' lg')
    editor.wait("return vim.bo.buftype == 'terminal'")
    assert editor.lua('return require("config.terminal").lazygit.job') == gitjob
    time.sleep(.3)
    editor.call('nvim_input', 'q')
    editor.wait('return require("config.terminal").lazygit == nil')
    editor.wait('return vim.api.nvim_get_current_win()', origin)
    editor.wait('return vim.api.nvim_get_current_line()', 'external changed')
    editor.lua('vim.api.nvim_win_set_cursor(0,{2,1})')
    editor.call('nvim_input', ' lg')
    editor.wait("return vim.bo.buftype == 'terminal'")
    one.write_text('external changed\nsecond updated\n')
    time.sleep(.3)
    editor.call('nvim_input', 'q')
    editor.wait('return require("config.terminal").lazygit == nil')
    editor.wait('return vim.api.nvim_win_get_cursor(0)', [2, 1])
    editor.lua('vim.api.nvim_win_set_cursor(0,{1,0})')
    editor.lua("vim.api.nvim_buf_set_lines(0,0,1,false,{'unsaved'})")
    editor.call('nvim_input', ' lg')
    editor.wait("return vim.bo.buftype == 'terminal'")
    one.write_text('another external\n')
    time.sleep(.3)
    editor.call('nvim_input', 'q')
    editor.wait('return require("config.terminal").lazygit == nil')
    editor.wait('return vim.api.nvim_get_current_line()', 'unsaved')
    assert editor.lua('return vim.v.errmsg') == '', editor.lua('return vim.v.errmsg')
    missing = editor.lua("local old=vim.fn.exepath; local message; vim.fn.exepath=function(name) if name=='lazygit' then return '' end; return old(name) end; local notify=vim.notify; vim.notify=function(m) message=m end; require('config.terminal').git(); vim.fn.exepath=old; vim.notify=notify; return message")
    assert 'Install LazyGit' in missing
    editor.close()
    editor = Editor((str(one),))
    editor.wait('return vim.v.vim_did_enter', 1)
    editor.lua("vim.api.nvim_buf_set_lines(0,0,-1,false,{'uniqueword completionword',''}); vim.api.nvim_win_set_cursor(0,{2,0})")
    editor.call('nvim_input', 'iun')
    editor.wait("return require('blink.cmp').is_visible()")
    assert editor.lua("return require('blink.cmp').get_selected_item() == nil")
    editor.call('nvim_input', '<C-y>')
    time.sleep(.1)
    assert editor.lua('return vim.api.nvim_get_current_line()') == 'un', 'Unselected Ctrl-y'
    editor.call('nvim_input', '<CR>')
    editor.wait('return vim.api.nvim_buf_line_count(0)', 3)
    assert editor.lua("return vim.api.nvim_buf_get_lines(0,1,2,false)[1]") == 'un', 'Enter never accepts'
    editor.call('nvim_input', 'un')
    editor.wait("return require('blink.cmp').is_visible()")
    editor.call('nvim_input', '<C-n>')
    editor.wait("return require('blink.cmp').get_selected_item() ~= nil")
    assert editor.lua('return vim.api.nvim_get_current_line()') == 'un', 'Selection does not insert'
    label = editor.lua("return require('blink.cmp').get_selected_item().label")
    editor.call('nvim_input', '<C-y>')
    editor.wait('return vim.api.nvim_get_current_line()', label)
    editor.call('nvim_input', '<Esc>')
    editor.lua("vim.cmd.enew({bang=true}); vim.bo.filetype='lua'")
    editor.call('nvim_input', 'i')
    editor.lua("vim.snippet.expand('hello(${1:value})$0')")
    assert editor.lua('return vim.snippet.active()'), 'Native snippet placeholders'
    editor.call('nvim_input', '<Tab><Esc>')
    editor.lua("vim.cmd.enew({bang=true}); vim.bo.filetype='zsh'; vim.api.nvim_buf_set_lines(0,0,-1,false,{'zshcompletionword',''}); vim.api.nvim_win_set_cursor(0,{2,0})")
    editor.call('nvim_input', 'izshc')
    editor.wait("return require('blink.cmp').is_visible()")
    assert editor.lua("return #vim.lsp.get_clients({bufnr=0}) == 0"), 'Zsh buffer completion without LSP'
    editor.call('nvim_input', '<Esc>')
    editor.lua("vim.api.nvim_buf_set_lines(0,0,-1,false,{''}); vim.api.nvim_win_set_cursor(0,{1,0})")
    editor.call('nvim_input', 'i' + fixture + '/')
    editor.wait("return require('blink.cmp').is_visible()")
    assert editor.lua("for _,i in ipairs(require('blink.cmp').get_items()) do if i.source_id == 'path' then return true end end; return false"), 'Real Zsh path completion'
    editor.close()
    stdin = subprocess.run(['nvim', '--headless', '-u', str(ROOT / 'init.lua'), '-', '-c',
                            "lua vim.defer_fn(function() assert(vim.bo.filetype ~= 'dashboard'); assert(vim.api.nvim_get_current_line() == 'stdin fixture'); vim.cmd('qa!') end, 100)"],
                           input='stdin fixture\n', text=True, capture_output=True, env=ENV, timeout=5)
    assert stdin.returncode == 0, stdin.stderr
print('PASS: attached startup/tree/picker, Leap, completion/snippets/Zsh, real shell PTYs/cwd/layout/focus/exits and LazyGit/toggle/exit/reload/protection; real stdin')
