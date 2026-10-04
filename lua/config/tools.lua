local M = { manifest = {
  ['bash-language-server'] = '5.8.1', ['typescript-language-server'] = '6.0.1',
  ['lua-language-server'] = '3.19.1', pyright = '1.1.414', ruff = '0.16.10', shellcheck = 'v0.11.0',
  stylua = 'v2.5.2', shfmt = 'v3.14.1', prettier = '3.9.9', ['eslint-lsp'] = '4.10.0',
} }
function M.path(name)
  local suffix = vim.fn.has('win32') == 1 and (name == 'ruff' or name == 'shellcheck' or name == 'lua-language-server') and '.exe'
    or (vim.fn.has('win32') == 1 and '.cmd' or '')
  return vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'bin', name .. suffix)
end
function M.available(name) return vim.fn.executable(M.path(name)) == 1 end
function M.executable(name) return name == 'eslint-lsp' and 'vscode-eslint-language-server' or name == 'pyright' and 'pyright-langserver' or name end
return M
