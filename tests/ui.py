"""Real attached UI and RPC input. Requires msgpack in an isolated test venv."""
import os
import pathlib
import select
import subprocess
import tempfile
import time
import msgpack

ROOT = pathlib.Path(__file__).resolve().parents[1]
BASE = pathlib.Path(os.environ['DOTNEOVIM_TEST_HOME'])
ENV = dict(os.environ, **{f'XDG_{k}_HOME': str(BASE / k.lower()) for k in ['CONFIG', 'DATA', 'STATE', 'CACHE']})


class Editor:
    def __init__(self, args=()):
        self.p = subprocess.Popen(['nvim', '--embed', '-u', str(ROOT / 'init.lua'), *args],
                                  stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=ENV)
        self.unpack = msgpack.Unpacker(raw=False)
        self.serial = 0
        self.redraws = []
        self.errors = b''
        self.messages = []
        self.call('nvim_ui_attach', 160, 50, {'rgb': True, 'ext_linegrid': True, 'ext_messages': True})

    def call(self, method, *args):
        self.serial += 1
        ident = self.serial
        self.p.stdin.write(msgpack.packb([0, ident, method, args]))
        self.p.stdin.flush()
        deadline = time.monotonic() + 10
        while time.monotonic() < deadline:
            for message in self.unpack:
                self.messages.append(message if message[0] != 2 or message[1] != 'redraw' else [2, 'redraw'])
                if message[0] == 2 and message[1] == 'redraw':
                    self.redraws.extend(message[2])
                    for event in message[2]:
                        if event[0] == 'msg_show':
                            self.errors += repr(event).encode()
                if message[0] == 1 and message[1] == ident:
                    assert message[2] is None, message[2]
                    return message[3]
            readable = select.select([self.p.stdout, self.p.stderr], [], [], .1)[0]
            if self.p.stderr in readable:
                self.errors += os.read(self.p.stderr.fileno(), 65536)
            if self.p.stdout in readable:
                data = os.read(self.p.stdout.fileno(), 65536)
                assert data, self.p.stderr.read().decode()
                self.unpack.feed(data)
        raise AssertionError(f'RPC timeout: {method}: {self.errors.decode()}: {self.messages[-10:]}')

    def lua(self, code):
        return self.call('nvim_exec_lua', code, [])

    def wait(self, code, expected=True):
        deadline = time.monotonic() + 5
        while time.monotonic() < deadline:
            if self.lua(code) == expected:
                return
            time.sleep(.03)
        raise AssertionError(code)

    def close(self):
        self.lua("vim.schedule(function() vim.cmd('qa!') end)")
        assert self.p.wait(timeout=5) == 0, self.p.stderr.read().decode()


with tempfile.TemporaryDirectory(prefix='dotneovim ui space ') as fixture:
    one = pathlib.Path(fixture) / 'one.txt'
    two = pathlib.Path(fixture) / 'two.txt'
    one.write_text('hello world\n')
    two.write_text('second\n')
    for args, dashboard in [((), True), ((fixture,), True), ((str(one),), False),
                            ((str(one), str(two)), False), ((fixture + '/COMMIT_EDITMSG',), False)]:
        editor = Editor(args)
        editor.wait('return vim.v.vim_did_enter', 1)
        time.sleep(.3)
        assert (editor.lua('return vim.bo.filetype') == 'dashboard') == dashboard, args
        assert editor.lua('return vim.v.errmsg') == ''
        assert any(event[0] == 'grid_line' for event in editor.redraws), 'Attached grid drawn'
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
print('PASS: attached startup matrix, first dashboard tree/picker/controls, real stdin')
