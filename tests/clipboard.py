"""Actual macOS clipboard mappings, restoring every original item/type in finally."""
import pathlib
import subprocess
import tempfile
import time
from ui_client import Editor, ROOT

with tempfile.TemporaryDirectory(prefix='dotneovim clipboard ') as fixture:
    helper = pathlib.Path(fixture) / 'pasteboard'
    subprocess.run(['swiftc', str(ROOT / 'tests/pasteboard.swift'), '-o', str(helper)], check=True, timeout=60)
    original = subprocess.check_output([str(helper), 'snapshot'], timeout=5)
    editor = None
    try:
        editor = Editor((str(pathlib.Path(fixture) / 'clipboard.txt'),))
        editor.wait('return vim.v.vim_did_enter', 1)
        assert editor.lua("return vim.fn['provider#clipboard#Executable']()") == 'pbcopy'
        editor.lua("vim.api.nvim_buf_set_lines(0,0,-1,false,{'roundtrip replacement'}); vim.api.nvim_win_set_cursor(0,{1,0})")
        editor.call('nvim_input', ' yiw')
        editor.wait("return vim.fn.getreg('+')", 'roundtrip')
        assert subprocess.check_output(['pbpaste']).decode() == 'roundtrip'
        editor.call('nvim_input', 'wviw p')
        editor.wait('return vim.api.nvim_get_current_line()', 'roundtrip roundtrip')
        assert subprocess.check_output(['pbpaste']).decode() == 'roundtrip'
        editor.call('nvim_input', '0yiwdiw')
        time.sleep(.1)
        assert subprocess.check_output(['pbpaste']).decode() == 'roundtrip'
        editor.lua("vim.api.nvim_buf_set_lines(0,0,-1,false,{'visual source'}); vim.api.nvim_win_set_cursor(0,{1,0})")
        editor.call('nvim_input', 'viw y')
        editor.wait("return vim.fn.getreg('+')", 'visual')
        assert subprocess.check_output(['pbpaste']).decode() == 'visual'
        editor.call('nvim_input', '$ p')
        editor.wait('return vim.api.nvim_get_current_line()', 'visual sourcevisual')
        assert editor.lua('return vim.o.clipboard') == ''
        assert editor.lua('return vim.v.errmsg') == ''
    finally:
        try:
            if editor is not None and editor.p.poll() is None:
                editor.close()
        finally:
            subprocess.run([str(helper), 'restore'], input=original, check=True, timeout=5)
            restored = subprocess.check_output([str(helper), 'snapshot'], timeout=5)
            import json
            assert json.loads(restored) == json.loads(original), 'Complete pasteboard restoration'
print('PASS: actual pbcopy/pbpaste operator/visual yanks, paste/source isolation; all prior pasteboard items/types restored')
