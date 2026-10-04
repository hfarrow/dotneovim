local M = { shells = {}, lazygit = nil }
local origin
local switching = false
local directory
local function remember()
  if vim.bo.buftype ~= 'terminal' then origin = vim.api.nvim_get_current_win(); directory = require('config.project').directory() end
end
function M.refresh()
  if switching then return end
  vim.schedule(function()
    -- A newer terminal may have opened before the previous close callback runs.
    if vim.bo.buftype == 'terminal' then return end
    if origin and vim.api.nvim_win_is_valid(origin) then vim.api.nvim_set_current_win(origin) end
    vim.cmd.stopinsert()
    vim.api.nvim_exec_autocmds('FocusGained', {})
    if package.loaded.gitsigns then require('gitsigns').refresh() end
    if package.loaded['nvim-tree.api'] then require('nvim-tree.api').tree.reload() end
  end)
end
local function maps(buf, close, git)
  vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { buffer = buf, desc = 'Terminal normal mode' })
  for _, dir in ipairs({ 'h', 'j', 'k', 'l' }) do
    vim.keymap.set('t', '<C-' .. dir .. '>', '<cmd>wincmd ' .. dir .. '<cr>', { buffer = buf, desc = 'Terminal split ' .. dir })
  end
  vim.keymap.set({ 'n', 't' }, '<C-g>', close, { buffer = buf, desc = git and 'Hide LazyGit' or 'Hide shell' })
  if git then vim.keymap.set('n', '<leader>lg', close, { buffer = buf, desc = 'Hide dedicated LazyGit' }) end
end
local function close_shells(except)
  switching = true
  for _, term in pairs(M.shells) do if term ~= except and term:is_open() then term:close() end end
  switching = false
end
function M.shell(direction)
  remember()
  if M.lazygit and M.lazygit.win and vim.api.nvim_win_is_valid(M.lazygit.win) then switching = true; M.hide_git(); switching = false end
  local term = M.shells[direction]
  if not term then
    term = require('toggleterm.terminal').Terminal:new({
      count = ({ horizontal = 1, vertical = 2, float = 3 })[direction],
      direction = direction, dir = directory or require('config.project').directory(),
      on_open = function(t) maps(t.bufnr, function() t:close() end, false) end,
      on_close = M.refresh,
      on_exit = function() M.shells[direction] = nil; M.refresh() end,
    })
    M.shells[direction] = term
  end
  close_shells(term)
  term:toggle()
end
function M.git_root(dir)
  local result = vim.system({ 'git', '-C', dir, 'rev-parse', '--show-toplevel' }, { text = true }):wait(2000)
  if result.code == 0 then return vim.trim(result.stdout) end
end
function M.hide_git()
  local git = M.lazygit
  if git and git.win and vim.api.nvim_win_is_valid(git.win) then vim.api.nvim_win_close(git.win, true) end
  if git then git.win = nil end
  M.refresh()
end
function M.git()
  local git = M.lazygit
  if git and git.win and vim.api.nvim_win_is_valid(git.win) then M.hide_git(); return end
  remember()
  local dir = require('config.project').directory()
  local root = M.git_root(dir)
  if not root then vim.notify('LazyGit requires a Git project/worktree', vim.log.levels.WARN); return end
  local executable = vim.fn.exepath('lazygit')
  if executable == '' then vim.notify('Install LazyGit and put lazygit on PATH (brew install lazygit)', vim.log.levels.WARN); return end
  close_shells()
  if git and git.root ~= root then
    vim.fn.jobstop(git.job)
    if vim.api.nvim_buf_is_valid(git.buf) then vim.api.nvim_buf_delete(git.buf, { force = true }) end
    git = nil
  end
  if not git or not vim.api.nvim_buf_is_valid(git.buf) then git = { root = root, buf = vim.api.nvim_create_buf(false, true) }; M.lazygit = git end
  local width, height = math.max(20, math.floor(vim.o.columns * 0.9)), math.max(8, math.floor(vim.o.lines * 0.85))
  git.win = vim.api.nvim_open_win(git.buf, true, { relative = 'editor', width = width, height = height,
    col = math.floor((vim.o.columns - width) / 2), row = math.floor((vim.o.lines - height) / 2), border = 'rounded', style = 'minimal', title = ' LazyGit ', title_pos = 'center' })
  if not git.job then
    git.job = vim.fn.jobstart({ executable }, { term = true, cwd = root,
      on_exit = function()
        vim.schedule(function()
          if M.lazygit == git then M.hide_git(); M.lazygit = nil end
          if vim.api.nvim_buf_is_valid(git.buf) then vim.api.nvim_buf_delete(git.buf, { force = true }) end
        end)
      end,
    })
    if git.job <= 0 then M.hide_git(); M.lazygit = nil; vim.notify('LazyGit process could not start', vim.log.levels.WARN); return end
    maps(git.buf, M.hide_git, true)
  end
  vim.cmd.startinsert()
end
return M
