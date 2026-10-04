local M = { bytes = 1024 * 1024, line = 10000 }
function M.check(buf)
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
  if vim.bo[buf].buftype ~= '' then return false end
  if vim.b[buf].dotneovim_large then return true end
  local size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
  local large = size > M.bytes
  if not large then
    for _, text in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
      if #text > M.line then large = true; break end
    end
  end
  if large then
    vim.b[buf].dotneovim_large = true
    pcall(vim.treesitter.stop, buf)
    if package.loaded['rainbow-delimiters'] then require('rainbow-delimiters').disable(buf) end
    if package.loaded['render-markdown'] then
      vim.api.nvim_buf_call(buf, function() require('render-markdown').buf_disable() end)
    end
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do vim.lsp.buf_detach_client(buf, client.id) end
  end
  return large
end
function M.setup()
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileType', 'TextChanged', 'TextChangedI' }, {
    group = vim.api.nvim_create_augroup('dotneovim.largefile', { clear = true }),
    callback = function(ev) M.check(ev.buf) end,
  })
end
return M
