local M = { parsers = { 'lua', 'bash', 'javascript', 'typescript', 'tsx', 'python', 'c_sharp', 'rust', 'markdown', 'markdown_inline', 'vim', 'vimdoc', 'query' } }
local warned = {}
function M.attach(buf)
  if vim.bo[buf].buftype ~= '' or require('config.largefile').check(buf) then return end
  local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
  if not vim.tbl_contains(M.parsers, lang) then return end
  local ok = pcall(vim.treesitter.start, buf, lang)
  if not ok then
    if not warned[lang] then
      warned[lang] = true
      vim.schedule(function() vim.notify('Missing parser: ' .. lang .. '. Run nvim -l scripts/parsers.lua', vim.log.levels.WARN) end)
    end
    return
  end
  local query_ok, query = pcall(vim.treesitter.query.get, lang, 'textobjects')
  if not query_ok or not query then return end
  local captures = {}
  for _, capture in ipairs(query.captures) do captures['@' .. capture] = true end
  local cleanup = {}
  local function map(modes, lhs, callback, desc)
    vim.keymap.set(modes, lhs, callback, { buffer = buf, desc = desc })
    for _, mode in ipairs(modes) do cleanup[#cleanup + 1] = string.format('silent! %sunmap <buffer> %s', mode, lhs) end
  end
  for key, capture in pairs({ af = '@function.outer', ['if'] = '@function.inner', ac = '@class.outer', ic = '@class.inner', aa = '@parameter.outer', ia = '@parameter.inner' }) do
    if captures[capture] then
      map({ 'x', 'o' }, key, function() require('nvim-treesitter-textobjects.select').select_textobject(capture, 'textobjects') end, 'Select ' .. capture)
    end
  end
  for _, obj in ipairs({ { 'm', 'function' }, { 'c', 'class' }, { 'a', 'parameter' } }) do
    local capture = '@' .. obj[2] .. '.outer'
    if captures[capture] then
      for _, motion in ipairs({ { ']', obj[1], 'goto_next_start' }, { '[', obj[1], 'goto_previous_start' }, { ']', obj[1]:upper(), 'goto_next_end' }, { '[', obj[1]:upper(), 'goto_previous_end' } }) do
        map({ 'n', 'x', 'o' }, motion[1] .. motion[2], function() require('nvim-treesitter-textobjects.move')[motion[3]](capture, 'textobjects') end, 'Move ' .. capture)
      end
    end
  end
  vim.b[buf].undo_ftplugin = (vim.b[buf].undo_ftplugin or '') .. ' | ' .. table.concat(cleanup, ' | ')
end
function M.setup()
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('dotneovim.reading', { clear = true }),
    callback = function(ev) M.attach(ev.buf) end,
  })
end
return M
