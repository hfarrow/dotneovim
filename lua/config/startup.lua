vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local group = vim.api.nvim_create_augroup('dotneovim.startup', { clear = true })
local stdin = false
vim.api.nvim_create_autocmd('StdinReadPre', { group = group, callback = function() stdin = true end })
vim.api.nvim_create_autocmd('VimEnter', {
  group = group, once = true,
  callback = function()
    local count = vim.fn.argc()
    local directory = count == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
    if stdin or (count > 0 and not directory) or vim.bo.buftype ~= '' then return end
    if directory then
      local path = vim.fn.fnamemodify(vim.fn.argv(0), ':p')
      vim.cmd.cd(path)
      vim.cmd.enew()
    elseif vim.api.nvim_buf_get_name(0) ~= '' or vim.bo.modified then
      return
    end
    vim.schedule(function()
      if vim.fn.exists(':Dashboard') == 2 then vim.cmd('Dashboard') end
    end)
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = function(ev)
    if vim.v.vim_did_enter == 0 then return end
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if name == '' or vim.fn.isdirectory(name) ~= 1 then return end
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(ev.buf) then return end
      require('nvim-tree.api').tree.open({ path = name })
    end)
  end,
})
