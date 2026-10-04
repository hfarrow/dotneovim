local group = vim.api.nvim_create_augroup('dotneovim.core', { clear = true })
local function wrap_policy()
  local buf = vim.api.nvim_get_current_buf()
  if vim.w.dotneovim_wrap_buf ~= buf then
    vim.w.dotneovim_wrap = nil
    vim.w.dotneovim_wrap_buf = buf
  end
  local prose = vim.bo.filetype == 'markdown' or vim.bo.filetype == 'text'
  local wrap = vim.w.dotneovim_wrap
  vim.wo.wrap = wrap == nil and prose or wrap == true
  vim.wo.linebreak = vim.wo.wrap
  vim.wo.breakindent = vim.wo.wrap
end

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter', 'FileType' }, {
  group = group,
  callback = wrap_policy,
  desc = 'Apply per-buffer reading display without rewriting lines',
})
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  callback = function()
    vim.opt_local.formatoptions:remove({ 't', 'c', 'a' })
  end,
  desc = 'Keep physical wrapping explicit',
})
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  group = group,
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= '' or vim.bo[ev.buf].modified or vim.fn.mode():match('[ciR]') then
      return
    end
    local views = {}
    for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
      views[win] = vim.api.nvim_win_call(win, vim.fn.winsaveview)
    end
    vim.cmd('silent! checktime ' .. ev.buf)
    for win, view in pairs(views) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_call(win, function() vim.fn.winrestview(view) end)
      end
    end
  end,
  desc = 'Reload external changes only for unmodified files, preserving view',
})
vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= '' or vim.bo[ev.buf].filetype == 'gitcommit' then return end
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = 'Restore valid last cursor position',
})
vim.api.nvim_create_autocmd('VimResized', {
  group = group, command = 'wincmd =', desc = 'Rebalance splits after resize',
})
