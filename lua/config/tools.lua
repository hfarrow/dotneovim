local M = { manifest = {
  ['bash-language-server'] = '5.8.1', ['typescript-language-server'] = '6.0.1',
  ['lua-language-server'] = '3.19.1', pyright = '1.1.414', ruff = '0.16.10', shellcheck = 'v0.11.0',
  stylua = 'v2.5.2', shfmt = 'v3.14.1', prettier = '3.9.9', ['eslint-lsp'] = '4.10.0',
} }
function M.suffix(name, windows)
  if windows == nil then windows = vim.fn.has('win32') == 1 end
  if not windows then return '' end
  return vim.tbl_contains({ 'ruff', 'shellcheck', 'lua-language-server', 'stylua', 'shfmt', 'black' }, name) and '.exe' or '.cmd'
end
function M.path(name)
  local suffix = M.suffix(name)
  return vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'bin', name .. suffix)
end
function M.venv_executable(root, name, windows)
  if windows == nil then windows = vim.fn.has('win32') == 1 end
  return vim.fs.joinpath(root, windows and 'Scripts' or 'bin', name .. (windows and '.exe' or ''))
end
function M.available(name) return vim.fn.executable(M.path(name)) == 1 end
function M.executable(name) return name == 'eslint-lsp' and 'vscode-eslint-language-server' or name == 'pyright' and 'pyright-langserver' or name end
return M
