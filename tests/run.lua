-- Script-mode harness: isolate runtime state and bound every child process.
local root = vim.fs.dirname(vim.fs.dirname(vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p')))
local base = assert(vim.env.DOTNEOVIM_TEST_HOME, 'Set DOTNEOVIM_TEST_HOME to an isolated directory')
local env = {
  XDG_CONFIG_HOME = base .. '/config', XDG_DATA_HOME = base .. '/data',
  XDG_STATE_HOME = base .. '/state', XDG_CACHE_HOME = base .. '/cache',
}
local args = { 'nvim', '--headless', '-u', root .. '/init.lua' }
local test = arg[1] or 'core'
args[#args + 1] = '-c'
args[#args + 1] = "lua local ok, err = pcall(dofile, " .. string.format('%q', root .. '/tests/' .. test .. '.lua') .. "); if not ok then print(err); vim.cmd('cquit 1') end"
local result = vim.system(args, { env = env, text = true }):wait(30000)
print(result.stdout or '')
print(result.stderr or '')
assert(result.code == 0, 'Test process failed: ' .. result.code)
