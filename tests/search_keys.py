"""Actual cold/warm leader dispatch and mapping ownership, using attached input."""
import pathlib
import json
import tempfile
import time

from ui_client import Editor


PAIRS = [
    ("f'", 'files', 'normal', 'Find files (normal)'),
    ('f"', 'grep', 'normal', 'Search content (normal)'),
    ('fg', 'files', 'hidden', 'Find files (hidden)'),
    ('fG', 'grep', 'hidden', 'Search content (hidden)'),
    ('fa', 'files', 'all', 'Find files (all, ignored)'),
    ('fA', 'grep', 'all', 'Search content (all, ignored)'),
]


def audit(editor):
    editor.lua("require('lazy').load({plugins={'conform.nvim','which-key.nvim'}})")
    time.sleep(.05)
    # Audit declarations too: Neovim itself hides duplicates by last-write wins.
    editor.lua("""
        local counts = {}
        for _, file in ipairs(vim.fn.glob(vim.g.dotneovim_root .. '/lua/plugins/*.lua', false, true)) do
          for _, plugin in ipairs(dofile(file)) do
            for _, key in ipairs(plugin.keys or {}) do
              local modes = key.mode or 'n'
              if type(modes) == 'string' then modes = { modes } end
              if vim.tbl_contains(modes, 'n') then
                local lhs = key[1]:gsub('<leader>', ' ')
                counts[lhs] = (counts[lhs] or 0) + 1
              end
            end
          end
        end
        for _, lhs in ipairs({" f'", ' f"', ' fg', ' fG', ' fa', ' fA'}) do
          assert(counts[lhs] == 1, 'Duplicate/missing declared owner: ' .. lhs)
        end
        assert(not counts[" '"] and not counts[' fh'], 'Retired key declared')
        assert(vim.fn.maparg(" '", 'n') == '' and vim.fn.maparg(' fh', 'n') == '', 'Retired mapping installed')
        local expected = {
          [' ff']='Format only (project policy)', [' fb']='Find buffers', [' fp']='Find project files',
        }
        for lhs, desc in pairs(expected) do
          assert(vim.fn.maparg(lhs,'n',false,true).desc == desc, 'Adjacent mapping changed: ' .. lhs)
        end
    """)
    for key, _, _, desc in PAIRS:
        lhs = ' ' + key
        result = editor.lua('return vim.fn.maparg(' + json.dumps(lhs) + ', "n", false, true).desc')
        assert result == desc, (key, result)
        # Which-key's intentionally non-consuming discovery triggers aren't action owners.
        maps = editor.lua("local maps=vim.api.nvim_get_keymap('n'); vim.list_extend(maps,vim.api.nvim_buf_get_keymap(0,'n')); local out={}; for _,m in ipairs(maps) do if m.lhs:sub(1,1)==' ' then out[#out+1]={lhs=m.lhs,desc=m.desc or ''} end end; return out")
        matches = [m for m in maps if m['lhs'] == lhs]
        assert len(matches) == 1, (lhs, matches)
        for mapping in maps:
            other = mapping['lhs']
            if other != lhs and (other.startswith(lhs) or lhs.startswith(other)):
                assert mapping.get('desc', '').startswith('which-key'), (lhs, mapping)


def invoke(editor, key, kind, mode):
    editor.call('nvim_input', ' ' + key)
    editor.wait("return vim.bo.filetype == 'TelescopePrompt'")
    title = f'{kind} · {mode} · directory'
    editor.wait("local p=require('telescope.actions.state').get_current_picker(vim.api.nvim_get_current_buf()); return p and p.prompt_title", title)
    if kind == 'grep':
        editor.call('nvim_input', 'needle')
    editor.wait("local p=require('telescope.actions.state').get_current_picker(vim.api.nvim_get_current_buf()); return p and p.manager and p.manager:num_results() > 0")
    editor.call('nvim_input', '<Esc><Esc>')
    editor.wait("return vim.bo.filetype ~= 'TelescopePrompt'")
    assert editor.lua('return vim.v.errmsg') == '', editor.errors.decode()


with tempfile.TemporaryDirectory(prefix='dotneovim paired search ') as directory:
    root = pathlib.Path(directory)
    (root / '.git').mkdir()
    (root / '.gitignore').write_text('ignored.txt\n')
    for name in ('normal.txt', '.hidden.txt', 'ignored.txt'):
        (root / name).write_text('needle ' + name + '\n')
    for key, kind, mode, _ in PAIRS:
        editor = Editor((str(root / 'normal.txt'),))
        try:
            editor.wait('return vim.v.vim_did_enter', 1)
            assert not editor.lua("return require('lazy.core.config').plugins['telescope.nvim']._.loaded ~= nil")
            invoke(editor, key, kind, mode)
            audit(editor)
        finally:
            editor.close()

    for args in ((str(root / 'normal.txt'),), (directory,)):
        editor = Editor(args)
        try:
            editor.wait('return vim.v.vim_did_enter', 1)
            if args == (directory,):
                editor.wait("return vim.bo.filetype == 'dashboard'")
                labels = editor.lua("local shortcuts=require('lazy.core.plugin').values(require('lazy.core.config').plugins['dashboard-nvim'], 'opts', false).config.shortcut; local labels={}; for _, item in ipairs(shortcuts) do labels[item.key]=item.desc end; return labels")
                assert {k: labels[k] for k in ('f', 'F', 'a', '/')} == {
                    'f': 'Files normal', 'F': 'Files hidden', 'a': 'Files all', '/': 'Content normal',
                }
            for key, kind, mode, _ in PAIRS:
                invoke(editor, key, kind, mode)
            audit(editor)
            if args == (directory,):
                for key, kind, mode in [('f', 'files', 'normal'), ('F', 'files', 'hidden'), ('a', 'files', 'all'), ('/', 'grep', 'normal')]:
                    editor.call('nvim_input', key)
                    editor.wait("return vim.bo.filetype == 'TelescopePrompt'")
                    editor.wait("local p=require('telescope.actions.state').get_current_picker(vim.api.nvim_get_current_buf()); return p.prompt_title", f'{kind} · {mode} · directory')
                    editor.call('nvim_input', '<Esc><Esc>')
                    editor.wait("return vim.bo.filetype == 'dashboard'")
        finally:
            editor.close()

print('PASS: six paired searches cold/warm/dashboard, source/runtime owners/prefixes, adjacent keys and dashboard labels/actions')
