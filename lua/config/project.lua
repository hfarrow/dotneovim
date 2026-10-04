local M = {}

function M.directory(buf)
  local name = vim.api.nvim_buf_get_name(buf or 0)
  if name ~= '' and vim.bo[buf or 0].buftype == '' then
    return vim.fn.isdirectory(name) == 1 and name or vim.fs.dirname(name)
  end
  return vim.fn.getcwd()
end

function M.root(dir)
  dir = vim.fs.normalize(dir or M.directory())
  -- Bounded lookup: never traverse beyond the home directory into host roots.
  local home = vim.fs.normalize(vim.uv.os_homedir())
  for _ = 1, 64 do
    for _, marker in ipairs({ '.git', 'package.json', 'pyproject.toml', '.luarc.json', 'Cargo.toml', 'go.mod' }) do
      if vim.uv.fs_stat(vim.fs.joinpath(dir, marker)) then return dir end
    end
    local parent = vim.fs.dirname(dir)
    if dir == home or not parent or parent == dir then break end
    dir = parent
  end
end

return M
