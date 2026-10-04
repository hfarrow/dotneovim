"""Small attached Neovim RPC client shared by executable UI fixtures."""
import os
import pathlib
import select
import subprocess
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
