local M = { bytes = 1024 * 1024, line = 10000, lines = 50000 }
local checked = {}
function M.check(buf)
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
  if vim.bo[buf].buftype ~= '' then return false end
  if vim.b[buf].dotneovim_large then
    -- Native ftplugins can start a highlighter after BufReadPost marked it.
    if vim.treesitter.highlighter.active[buf] then pcall(vim.treesitter.stop, buf) end
    vim.bo[buf].syntax = 'OFF'
    return true
  end
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  if checked[buf] == tick then return false end
  checked[buf] = tick
  local count = vim.api.nvim_buf_line_count(buf)
  local size = vim.api.nvim_buf_get_offset(buf, count)
  local large = size > M.bytes or count > M.lines
  if not large then
    for _, text in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
      if #text > M.line then large = true; break end
    end
  end
  if large then
    vim.b[buf].dotneovim_large = true
    vim.bo[buf].syntax = 'OFF'
    vim.bo[buf].synmaxcol = 200
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
  local group = vim.api.nvim_create_augroup('dotneovim.largefile', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileType', 'TextChanged', 'TextChangedI' }, {
    group = group,
    callback = function(ev) M.check(ev.buf) end,
  })
  vim.api.nvim_create_autocmd('BufWipeout', { group = group, callback = function(ev) checked[ev.buf] = nil end })
  vim.api.nvim_create_autocmd('Syntax', { group = group, callback = function(ev)
    if vim.b[ev.buf].dotneovim_large and vim.bo[ev.buf].syntax ~= 'OFF' then
      vim.bo[ev.buf].syntax = 'OFF'
    end
  end })
end
return M
