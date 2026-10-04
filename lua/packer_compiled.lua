-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/heath.farrow/.cache/nvim/packer_hererocks/2.1.1741730670/share/lua/5.1/?.lua;/Users/heath.farrow/.cache/nvim/packer_hererocks/2.1.1741730670/share/lua/5.1/?/init.lua;/Users/heath.farrow/.cache/nvim/packer_hererocks/2.1.1741730670/lib/luarocks/rocks-5.1/?.lua;/Users/heath.farrow/.cache/nvim/packer_hererocks/2.1.1741730670/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/heath.farrow/.cache/nvim/packer_hererocks/2.1.1741730670/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  LuaSnip = {
    config = { "\27LJ\2\nO\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\14lazy_load\"luasnip.loaders.from_snipmate\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["barbar.nvim"] = {
    config = { "\27LJ\2\nA\0\0\3\0\4\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\3\0L\0\2\0\nwidth\tView\19nvim-tree.view\frequire.\0\0\4\2\1\0\6-\0\0\0009\0\0\0-\2\1\0B\2\1\0A\0\0\1K\0\1\0\1¿\2¿\15set_offset.\0\0\4\2\1\0\6-\0\0\0009\0\0\0-\2\1\0B\2\1\0A\0\0\1K\0\1\0\1¿\2¿\15set_offset(\0\0\3\1\1\0\5-\0\0\0009\0\0\0)\2\0\0B\0\2\1K\0\1\0\1¿\15set_offset™\r\1\0\n\0L\0ß\0016\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\0034\4\0\0166\5\a\0009\5\b\0059\5\t\0059\5\n\0055\6\v\0<\6\5\0046\5\a\0009\5\b\0059\5\t\0059\5\f\0055\6\r\0<\6\5\0046\5\a\0009\5\b\0059\5\t\0059\5\14\0055\6\15\0<\6\5\0046\5\a\0009\5\b\0059\5\t\0059\5\16\0055\6\17\0<\6\5\4=\4\18\3=\3\19\2B\0\2\0016\0\0\0'\2\20\0B\0\2\0026\1\0\0'\3\21\0B\1\2\0023\2\22\0009\3\23\0'\5\24\0003\6\25\0B\3\3\0019\3\23\0'\5\26\0003\6\27\0B\3\3\0019\3\23\0'\5\28\0003\6\29\0B\3\3\0016\3\0\0'\5\30\0B\3\2\0029\4\31\0039\4 \0049\5!\3'\a\"\0'\b#\0\18\t\4\0B\5\4\0019\5!\3'\a$\0'\b%\0\18\t\4\0B\5\4\0019\5!\3'\a&\0'\b'\0\18\t\4\0B\5\4\0019\5!\3'\a(\0'\b)\0\18\t\4\0B\5\4\0019\5!\3'\a*\0'\b+\0\18\t\4\0B\5\4\0019\5!\3'\a,\0'\b-\0\18\t\4\0B\5\4\0019\5!\3'\a.\0'\b/\0\18\t\4\0B\5\4\0019\5!\3'\a0\0'\b1\0\18\t\4\0B\5\4\0019\5!\3'\a2\0'\b3\0\18\t\4\0B\5\4\0019\5!\3'\a4\0'\b5\0\18\t\4\0B\5\4\0019\5!\3'\a6\0'\b7\0\18\t\4\0B\5\4\0019\5!\3'\a8\0'\b9\0\18\t\4\0B\5\4\0019\5!\3'\a:\0'\b;\0\18\t\4\0B\5\4\0019\5!\3'\a<\0'\b=\0\18\t\4\0B\5\4\0019\5!\3'\a>\0'\b?\0\18\t\4\0B\5\4\0019\5!\3'\a@\0'\bA\0\18\t\4\0B\5\4\0019\5!\3'\aB\0'\bC\0\18\t\4\0B\5\4\0019\5!\3'\aD\0'\bE\0\18\t\4\0B\5\4\0019\5!\3'\aF\0'\bG\0\18\t\4\0B\5\4\0019\5!\3'\aH\0'\bI\0\18\t\4\0B\5\4\0019\5!\3'\aJ\0'\bK\0\18\t\4\0B\5\4\0012\0\0ÄK\0\1\0'<Cmd>BufferOrderByWindowNumber<CR>\14<Space>bw#<Cmd>BufferOrderByLanguage<CR>\14<Space>bl$<Cmd>BufferOrderByDirectory<CR>\14<Space>bd'<Cmd>BufferOrderByBufferNumber<CR>\14<Space>bb\24<Cmd>BufferPick<CR>\n<C-p>\25<Cmd>BufferClose<CR>\n<A-c>\23<Cmd>BufferPin<CR>\n<A-p>\24<Cmd>BufferLast<CR>\n<A-0>\26<Cmd>BufferGoto 9<CR>\n<A-9>\26<Cmd>BufferGoto 8<CR>\n<A-8>\26<Cmd>BufferGoto 7<CR>\n<A-7>\26<Cmd>BufferGoto 6<CR>\n<A-6>\26<Cmd>BufferGoto 5<CR>\n<A-5>\26<Cmd>BufferGoto 4<CR>\n<A-4>\26<Cmd>BufferGoto 3<CR>\n<A-3>\26<Cmd>BufferGoto 2<CR>\n<A-2>\26<Cmd>BufferGoto 1<CR>\n<A-1>\28<Cmd>BufferMoveNext<CR>\n<A->> <Cmd>BufferMovePrevious<CR>\n<A-<>\24<Cmd>BufferNext<CR>\n<A-.>\28<Cmd>BufferPrevious<CR>\n<A-,>\nnbind\vsilent\rbind_opt\19user.functions\0\14TreeClose\0\vResize\0\rTreeOpen\14subscribe\0\19bufferline.api\21nvim-tree.events\nicons\16diagnostics\1\0\1\fenabled\1\tHINT\1\0\1\fenabled\1\tINFO\1\0\2\fenabled\2\ticon\bÔî©\tWARN\1\0\2\fenabled\2\ticon\bÔôô\nERROR\rseverity\15diagnostic\bvim\vpinned\1\0\2\vpinned\0\16diagnostics\0\1\0\1\vbutton\bÔ§Ç\1\0\5\20maximum_padding\3\1\nicons\0\rtabpages\2\19maximum_length\3\30\20minimum_padding\3\1\nsetup\15bufferline\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/barbar.nvim",
    url = "https://github.com/romgrk/barbar.nvim",
    wants = { "nvim-web-devicons" }
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-git"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/cmp-git",
    url = "https://github.com/hrsh7th/cmp-git"
  },
  ["cmp-nvim-lsp"] = {
    config = { "\27LJ\2\nB\0\0\3\0\4\0\0066\0\0\0009\0\1\0009\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\nfloat\1\14goto_prev\15diagnostic\bvimB\0\0\3\0\4\0\0066\0\0\0009\0\1\0009\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\nfloat\1\14goto_next\15diagnostic\bvim®\t\1\0\r\1/\1^6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0025\1\3\0006\2\0\0'\4\4\0B\2\2\0029\3\5\2'\5\6\0003\6\a\0\18\a\1\0B\3\4\0019\3\5\2'\5\b\0003\6\t\0\18\a\1\0B\3\4\0016\3\0\0'\5\n\0B\3\2\0029\3\v\0039\3\f\0035\5\18\0005\6\r\0006\a\14\0006\t\15\0009\t\16\t9\t\17\tB\t\1\0A\a\0\0?\a\0\0=\6\19\5B\3\2\0016\3\0\0'\5\n\0B\3\2\0029\3\20\0039\3\f\0035\5\21\0=\0\22\5-\6\0\0=\6\23\5B\3\2\0016\3\0\0'\5\n\0B\3\2\0029\3\24\0039\3\f\0035\5\25\0=\0\22\5-\6\0\0=\6\23\5B\3\2\0016\3\0\0'\5\n\0B\3\2\0029\3\26\0039\3\f\0035\5\27\0=\0\22\5-\6\0\0=\6\23\0055\6+\0005\a\29\0005\b\28\0=\b\30\a5\b \0005\t\31\0=\t!\b=\b\"\a5\b&\0006\t\15\0009\t#\t9\t$\t'\v%\0+\f\2\0B\t\3\2=\t'\b=\b(\a5\b)\0=\b*\a=\a,\6=\6-\5B\3\2\0016\3\0\0'\5\n\0B\3\2\0029\3.\0039\3\f\0034\5\0\0B\3\2\1K\0\1\0\2¿\vyamlls\rsettings\bLua\1\0\1\bLua\0\14telemetry\1\0\1\venable\1\14workspace\flibrary\1\0\2\flibrary\0\20checkThirdParty\1\5\26nvim_get_runtime_file\bapi\16diagnostics\fglobals\1\0\1\fglobals\0\1\2\0\0\bvim\fruntime\1\0\4\14workspace\0\fruntime\0\14telemetry\0\16diagnostics\0\1\0\1\fversion\vLuaJIT\1\0\3\rsettings\0\17capabilities\0\14on_attach\0\16sumneko_lua\1\0\2\17capabilities\0\14on_attach\0\fpyright\14on_attach\17capabilities\1\0\2\17capabilities\0\14on_attach\0\vbashls\bcmd\1\0\b\28sdk_include_prereleases\2\29enable_import_completion\1\31organize_imports_on_format\1\bcmd\0,enable_ms_build_load_projects_on_demand\1 enable_editorconfig_support\2\28enable_roslyn_analyzers\1 analyze_open_documents_only\1\vgetpid\afn\bvim\rtostring\1\4\0\0'/home/hfarrow/.local/omnisharp/run\21--languageserver\14--hostPID\nsetup\14omnisharp\14lspconfig\0\a]x\0\a[x\nnbind\19user.functions\1\0\2\fnoremap\2\vsilent\2\25default_capabilities\17cmp_nvim_lsp\frequire\tÄÄ¿ô\4\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["dashboard-nvim"] = {
    config = { "\27LJ\2\n«\14\0\0\n\0\26\0)6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\0035\4\a\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\0034\4\b\0005\5\r\0>\5\1\0045\5\14\0>\5\2\0045\5\15\0>\5\3\0045\5\16\0>\5\4\0045\5\17\0>\5\5\0045\5\18\0'\6\19\0006\a\0\0'\t\20\0B\a\2\0029\a\21\aB\a\1\2&\6\a\6=\6\22\5>\5\6\0045\5\23\0>\5\a\4=\4\24\3=\3\25\2B\0\2\1K\0\1\0\vconfig\rshortcut\1\0\5\tdesc\r/.config\ticon\tÔê• \bkey\6c\ngroup\nLabel\vaction'Telescope find_files cwd=~/.config\vaction\23get_dotneovim_path\19user.functions\30Telescope find_files cwd=\1\0\5\tdesc\r/.neovim\ticon\tÔê• \bkey\6n\ngroup\nLabel\vaction\0\1\0\5\tdesc\tTree\ticon\tÔêì \bkey\6y\ngroup\nLabel\vaction\19NvimTreeToggle\1\0\5\tdesc\14Find Word\ticon\tÔÜö \bkey\6/\ngroup\nLabel\vaction\24Telescope live_grep\1\0\5\tdesc\17Recent Files\ticon\nÔú°  \bkey\6;\ngroup\nLabel\vaction\23Telescope oldfiles\1\0\5\tdesc\14All Files\ticon\tÔÖú \bkey\6F\ngroup\nLabel\vactionVTelescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=üîç\1\0\5\tdesc\nFiles\ticon\tÔÖú \bkey\6f\ngroup\nLabel\vactionDTelescope find_files find_command=rg,--files prompt_prefix=üîç\bmru\1\0\2\rcwd_only\1\nlimit\3\20\fproject\1\0\1\venable\1\rpackages\1\0\1\venable\1\vheader\1\0\5\vheader\0\rshortcut\0\bmru\0\fproject\0\rpackages\0\1\a\0\0ä\1 ‚ñà‚ñà‚ñà‚ïó   ‚ñà‚ñà‚ïó ‚ñà‚ñà‚ñà‚ñà‚ñà‚ñà‚ñà‚ïó ‚ñà‚ñà‚ñà‚ñà‚ñà‚ñà‚ïó  ‚ñà‚ñà‚ïó   ‚ñà‚ñà‚ïó ‚ñà‚ñà‚ïó ‚ñà‚ñà‚ñà‚ïó   ‚ñà‚ñà‚ñà‚ïóî\1 ‚ñà‚ñà‚ñà‚ñà‚ïó  ‚ñà‚ñà‚ïë ‚ñà‚ñà‚ïî‚ïê‚ïê‚ïê‚ïê‚ïù‚ñà‚ñà‚ïî‚ïê‚ïê‚ïê‚ñà‚ñà‚ïó ‚ñà‚ñà‚ïë   ‚ñà‚ñà‚ïë ‚ñà‚ñà‚ïë ‚ñà‚ñà‚ñà‚ñà‚ïó ‚ñà‚ñà‚ñà‚ñà‚ïëé\1 ‚ñà‚ñà‚ïî‚ñà‚ñà‚ïó ‚ñà‚ñà‚ïë ‚ñà‚ñà‚ñà‚ñà‚ñà‚ïó  ‚ñà‚ñà‚ïë   ‚ñà‚ñà‚ïë ‚ñà‚ñà‚ïë   ‚ñà‚ñà‚ïë ‚ñà‚ñà‚ïë ‚ñà‚ñà‚ïî‚ñà‚ñà‚ñà‚ñà‚ïî‚ñà‚ñà‚ïëî\1 ‚ñà‚ñà‚ïë‚ïö‚ñà‚ñà‚ïó‚ñà‚ñà‚ïë ‚ñà‚ñà‚ïî‚ïê‚ïê‚ïù  ‚ñà‚ñà‚ïë   ‚ñà‚ñà‚ïë ‚ïö‚ñà‚ñà‚ïó ‚ñà‚ñà‚ïî‚ïù ‚ñà‚ñà‚ïë ‚ñà‚ñà‚ïë‚ïö‚ñà‚ñà‚ïî‚ïù‚ñà‚ñà‚ïëñ\1 ‚ñà‚ñà‚ïë ‚ïö‚ñà‚ñà‚ñà‚ñà‚ïë ‚ñà‚ñà‚ñà‚ñà‚ñà‚ñà‚ñà‚ïó‚ïö‚ñà‚ñà‚ñà‚ñà‚ñà‚ñà‚ïî‚ïù  ‚ïö‚ñà‚ñà‚ñà‚ñà‚ïî‚ïù  ‚ñà‚ñà‚ïë ‚ñà‚ñà‚ïë ‚ïö‚ïê‚ïù ‚ñà‚ñà‚ïëÜ\1 ‚ïö‚ïê‚ïù  ‚ïö‚ïê‚ïê‚ïê‚ïù ‚ïö‚ïê‚ïê‚ïê‚ïê‚ïê‚ïê‚ïù ‚ïö‚ïê‚ïê‚ïê‚ïê‚ïê‚ïù    ‚ïö‚ïê‚ïê‚ïê‚ïù   ‚ïö‚ïê‚ïù ‚ïö‚ïê‚ïù     ‚ïö‚ïê‚ïù\1\0\2\vconfig\0\ntheme\nhyper\nsetup\14dashboard\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/opt/dashboard-nvim",
    url = "https://github.com/nvimdev/dashboard-nvim"
  },
  ["diffview.nvim"] = {
    config = { "\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nf\0\0\3\0\4\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0 scrollbar.handlers.gitsigns\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["glow.nvim"] = {
    config = { "\27LJ\2\nÃ\1\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\t\14glow_path\18/usr/bin/glow\vheight\3Ë\a\vborder\vshadow\17height_ratio\4Õô≥Ê\fÃô≥ˇ\3\16width_ratio\4ÊÃô≥\6ÊÃôˇ\3\npager\1\nstyle\tdark\nwidth\3x\17install_path\17~/.local/bin\nsetup\tglow\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/glow.nvim",
    url = "https://github.com/ellisonleao/glow.nvim"
  },
  ["gruvbox-material"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/gruvbox-material",
    url = "https://github.com/sainnhe/gruvbox-material"
  },
  ["leap.nvim"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25add_default_mappings\tleap\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/leap.nvim",
    url = "https://github.com/ggandor/leap.nvim"
  },
  ["lsp_lines.nvim"] = {
    config = { "\27LJ\2\nö\1\0\0\4\1\b\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\3\0009\0\4\0009\0\5\0005\2\6\0-\3\0\0\19\3\3\0=\3\a\2B\0\2\1-\0\0\0\19\0\0\0.\0\0\0K\0\1\0\0\0\17virtual_text\1\0\1\17virtual_text\0\vconfig\15diagnostic\bvim\vtoggle\14lsp_lines\frequireü\1\0\0\5\1\a\0\0146\0\0\0009\0\1\0009\0\2\0005\2\5\0005\3\3\0-\4\0\0\19\4\4\0=\4\4\3=\3\6\2B\0\2\1-\0\0\0\19\0\0\0.\0\0\0K\0\1\0\1\0\18virtual_lines\1\0\1\18virtual_lines\0\22only_current_line\1\0\1\22only_current_line\0\vconfig\15diagnostic\bvim∫\2\1\0\b\2\15\0\0266\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\3\0009\0\4\0009\0\5\0005\2\6\0B\0\2\0013\0\a\0003\1\b\0006\2\0\0'\4\t\0B\2\2\0029\3\n\2'\5\v\0\18\6\0\0005\a\f\0B\3\4\0019\3\n\2'\5\r\0\18\6\1\0005\a\14\0B\3\4\1K\0\1\0\0\0\1\0\1\0\1\tdesc-Toggle virtual_lines - current line only\15<Leader>uX\1\0\1\tdesc&Toggle lsp_lines and virtual_text\15<Leader>ux\nnbind\19user.functions\0\0\1\0\1\17virtual_text\1\vconfig\15diagnostic\bvim\nsetup\14lsp_lines\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/lsp_lines.nvim",
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\no\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\foptions\1\0\1\foptions\0\1\0\1\ntheme\21gruvbox-material\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\nÇ\2\0\0\b\0\f\0\0226\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\0016\0\0\0'\2\6\0B\0\2\0026\1\0\0'\3\a\0B\1\2\0029\2\b\1\18\4\2\0009\2\t\2'\5\n\0009\6\v\0B\6\1\0A\2\2\1K\0\1\0\20on_confirm_done\17confirm_done\aon\nevent\bcmp\"nvim-autopairs.completion.cmp\21disable_filetype\1\0\1\21disable_filetype\0\1\3\0\0\20TelescopePrompt\bvim\nsetup\19nvim-autopairs\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\nÓ\1\0\0\b\0\t\2'6\0\0\0\14\0\0\0X\1\2Ä6\0\1\0009\0\0\0007\0\0\0006\0\0\0006\2\2\0009\2\3\0029\2\4\2)\4\0\0B\2\2\0A\0\0\3\b\1\0\0X\2\20Ä6\2\2\0009\2\3\0029\2\5\2)\4\0\0\23\5\1\0\18\6\0\0+\a\2\0B\2\5\2:\2\1\2\18\4\2\0009\2\6\2\18\5\1\0\18\6\1\0B\2\4\2\18\4\2\0009\2\a\2'\5\b\0B\2\3\2\n\2\0\0X\2\2Ä+\2\1\0X\3\1Ä+\2\2\0L\2\2\0\a%s\nmatch\bsub\23nvim_buf_get_lines\24nvim_win_get_cursor\bapi\bvim\ntable\vunpack\0\2C\0\1\4\0\4\0\a6\1\0\0'\3\1\0B\1\2\0029\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\15lsp_expand\fluasnip\frequireV\0\0\3\0\4\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0D\0\2\0\nspell\26in_treesitter_capture\23cmp.config.context\frequire≈\1\0\1\3\3\5\0\29-\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\1\1B\1\1\1X\1\19Ä-\1\1\0009\1\2\1B\1\1\2\15\0\1\0X\2\4Ä-\1\1\0009\1\3\1B\1\1\1X\1\nÄ-\1\2\0B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\4\1B\1\1\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\2¿\1¿\0¿\rcomplete\19expand_or_jump\23expand_or_jumpable\21select_next_item\fvisibleé\1\0\1\4\2\4\0\23-\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\1\1B\1\1\1X\1\rÄ-\1\1\0009\1\2\1)\3ˇˇB\1\2\2\15\0\1\0X\2\5Ä-\1\1\0009\1\3\1)\3ˇˇB\1\2\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\2¿\1¿\tjump\rjumpable\21select_prev_item\fvisible˛\a\1\0\r\0004\0o6\0\0\0009\0\1\0'\1\3\0=\1\2\0003\0\4\0006\1\5\0'\3\6\0B\1\2\0026\2\5\0'\4\a\0B\2\2\0029\3\b\0025\5\f\0005\6\n\0003\a\t\0=\a\v\6=\6\r\0059\6\14\0029\6\15\0064\b\4\0005\t\16\0>\t\1\b5\t\17\0>\t\2\b5\t\18\0005\n\19\0003\v\20\0=\v\21\n=\n\22\t>\t\3\b4\t\3\0005\n\23\0>\n\1\tB\6\3\2=\6\15\0059\6\24\0029\6\25\0069\6\26\0065\b\28\0009\t\24\0029\t\27\t)\v¸ˇB\t\2\2=\t\29\b9\t\24\0029\t\27\t)\v\4\0B\t\2\2=\t\30\b9\t\24\0029\t\31\tB\t\1\2=\t \b9\t\24\0029\t!\tB\t\1\2=\t\"\b9\t\24\0029\t#\t5\v$\0B\t\2\2=\t%\b9\t\24\0023\v&\0005\f'\0B\t\3\2=\t(\b9\t\24\0023\v)\0005\f*\0B\t\3\2=\t+\bB\6\2\2=\6\24\5B\3\2\0019\3\b\0029\3,\0035\5-\0005\6.\0009\a\24\0029\a\25\a9\a,\aB\a\1\2=\a\24\0064\a\3\0005\b/\0>\b\1\a=\a\15\6B\3\3\0019\3\b\0029\3,\3'\0050\0005\0061\0009\a\24\0029\a\25\a9\a,\aB\a\1\2=\a\24\0069\a\14\0029\a\15\a4\t\3\0005\n2\0>\n\1\t4\n\3\0005\v3\0>\v\1\nB\a\3\2=\a\15\6B\3\3\0012\0\0ÄK\0\1\0\1\0\1\tname\fcmdline\1\0\1\tname\tpath\1\0\2\fsources\0\fmapping\0\6:\1\0\1\tname\vbuffer\1\0\2\fsources\0\fmapping\0\1\3\0\0\6/\6?\fcmdline\f<S-Tab>\1\3\0\0\6i\6s\0\n<Tab>\1\3\0\0\6i\6s\0\t<CR>\1\0\1\vselect\2\fconfirm\n<C-e>\nabort\14<C-Space>\rcomplete\n<C-f>\n<C-b>\1\0\a\14<C-Space>\0\n<C-f>\0\n<Tab>\0\n<C-b>\0\t<CR>\0\f<S-Tab>\0\n<C-e>\0\16scroll_docs\vinsert\vpreset\fmapping\1\0\1\tname\vbuffer\voption\22enable_in_context\0\1\0\2\22enable_in_context\0\21keep_all_entries\1\1\0\2\voption\0\tname\nspell\1\0\1\tname\fluasnip\1\0\1\tname\rnvim_lsp\fsources\vconfig\fsnippet\1\0\3\fsources\0\fmapping\0\fsnippet\0\vexpand\1\0\1\vexpand\0\0\nsetup\bcmp\fluasnip\frequire\0\26menu,menuone,noselect\16completeopt\bopt\bvim\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-hlslens"] = {
    config = { "\27LJ\2\nÒ\5\0\0\a\0\21\00036\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0015\0\4\0006\1\0\0'\3\5\0B\1\2\0029\2\6\1'\4\a\0'\5\b\0\18\6\0\0B\2\4\0019\2\6\1'\4\t\0'\5\n\0\18\6\0\0B\2\4\0019\2\6\1'\4\v\0'\5\f\0\18\6\0\0B\2\4\0019\2\6\1'\4\r\0'\5\14\0\18\6\0\0B\2\4\0019\2\6\1'\4\15\0'\5\16\0\18\6\0\0B\2\4\0019\2\6\1'\4\17\0'\5\18\0\18\6\0\0B\2\4\0019\2\6\1'\4\19\0'\5\20\0\18\6\0\0B\2\4\1K\0\1\0\17<Cmd>noh<CR>\14<Leader>l.g#<Cmd>lua require('hlslens').start()<CR>\ag#.g*<Cmd>lua require('hlslens').start()<CR>\ag*-#<Cmd>lua require('hlslens').start()<CR>\6#y:let stay_star_view = winsaveview()<CR>*<Cmd>lua require('hlslens').start()<CR>:call winrestview(stay_star_view)<cr>\6*[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zz\6N[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zz\6n\nnbind\19user.functions\1\0\2\fnoremap\2\vsilent\2\30scrollbar.handlers.search\nsetup\fhlslens\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-hlslens",
    url = "https://github.com/kevinhwang91/nvim-hlslens"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-neoclip.lua"] = {
    config = { "\27LJ\2\nÜ\4\0\0\a\0\22\0$6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\0016\0\0\0'\2\3\0B\0\2\0029\0\4\0005\2\5\0005\3\16\0005\4\b\0005\5\6\0004\6\0\0=\6\a\5=\5\t\0045\5\n\0005\6\v\0=\6\f\0055\6\r\0=\6\14\0054\6\0\0=\6\a\5=\5\15\4=\4\1\3=\3\17\2B\0\2\0016\0\0\0'\2\18\0B\0\2\0029\0\19\0'\2\20\0'\3\21\0B\0\3\1K\0\1\0\27:Telescope neoclip<CR>\15<Leader>fp\nnbind\19user.functions\tkeys\1\0\1\14telescope\0\6n\17paste_behind\1\3\0\0\6:\6P\npaste\1\3\0\0\6;\6p\1\0\6\vcustom\0\vdelete\6d\vselect\t<cr>\npaste\0\vreplay\6q\17paste_behind\0\6i\1\0\2\6i\0\6n\0\vcustom\1\0\6\vcustom\0\vdelete\n<c-d>\vselect\t<cr>\npaste\6;\vreplay\n<c-q>\17paste_behind\n<c-p>\1\0\3\20continuous_sync\2\30enable_persistent_history\2\tkeys\0\nsetup\fneoclip\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-neoclip.lua",
    url = "https://github.com/AckslD/nvim-neoclip.lua"
  },
  ["nvim-scrollbar"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14scrollbar\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-scrollbar",
    url = "https://github.com/petertriho/nvim-scrollbar"
  },
  ["nvim-surround"] = {
    config = { "\27LJ\2\nÍ\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\fkeymaps\1\0\1\fkeymaps\0\1\0\n\16insert_line\vgC-ggZ\vdelete\bgzd\16visual_line\agZ\vvisual\agz\20normal_cur_line\bgZZ\16normal_line\bgzz\15normal_cur\agZ\vnormal\agz\vinsert\v<C-g>z\vchange\bgzc\nsetup\18nvim-surround\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-surround",
    url = "https://github.com/kylechui/nvim-surround"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\nä\1\0\0\5\0\a\0\0146\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0016\0\0\0'\2\3\0B\0\2\0029\1\4\0'\3\5\0'\4\6\0B\1\3\1K\0\1\0\24:NvimTreeToggle<CR>\14<Leader>y\nnbind\19user.functions\nsetup\14nvim-tree\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/nvim-tree/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nê\1\0\2\t\0\a\1\21*\2\0\0006\3\0\0006\5\1\0009\5\2\0059\5\3\0056\6\1\0009\6\4\0069\6\5\6\18\b\1\0B\6\2\0A\3\1\3\15\0\3\0X\5\aÄ\15\0\4\0X\5\5Ä9\5\6\4\1\2\5\0X\5\2Ä+\5\2\0L\5\2\0K\0\1\0\tsize\22nvim_buf_get_name\bapi\ffs_stat\tloop\bvim\npcallÄ¿\fà\2\1\0\5\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0003\4\5\0=\4\6\3=\3\a\0025\3\b\0=\3\t\0025\3\n\0=\3\v\2B\0\2\1K\0\1\0\frainbow\1\0\3\venable\2\18extended_mode\2\19max_file_lines\0\vindent\1\0\1\venable\2\14highlight\fdisable\0\1\0\2\venable\2\fdisable\0\1\0\4\vindent\0\frainbow\0\21ensure_installed\ball\14highlight\0\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    config = { "\27LJ\2\n¥\a\0\0\6\0\28\0\0316\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\26\0005\3\b\0005\4\3\0005\5\4\0=\5\5\0045\5\6\0=\5\a\4=\4\t\0035\4\n\0005\5\v\0=\5\f\0045\5\r\0=\5\14\4=\4\15\0035\4\16\0005\5\17\0=\5\18\0045\5\19\0=\5\20\0045\5\21\0=\5\22\0045\5\23\0=\5\24\4=\4\25\3=\3\27\2B\0\2\1K\0\1\0\16textobjects\1\0\1\16textobjects\0\tmove\22goto_previous_end\1\0\2\a[]\17@class.outer\a[M\20@function.outer\24goto_previous_start\1\0\2\a[[\17@class.outer\a[m\20@function.outer\18goto_next_end\1\0\2\a]M\20@function.outer\a][\17@class.outer\20goto_next_start\1\0\2\a]m\20@function.outer\a]]\17@class.outer\1\0\6\venable\2\24goto_previous_start\0\22goto_previous_end\0\18goto_next_end\0\20goto_next_start\0\14set_jumps\2\tswap\18swap_previous\1\0\1\14<leader>S\21@parameter.inner\14swap_next\1\0\1\14<leader>s\21@parameter.inner\1\0\3\venable\2\18swap_previous\0\14swap_next\0\vselect\1\0\3\tmove\0\vselect\0\tswap\0\20selection_modes\1\0\3\20@function.outer\6V\21@parameter.outer\6v\17@class.outer\n<C-v>\fkeymaps\1\0\6\aia\21@parameter.inner\aaf\20@function.outer\aaa\21@parameter.outer\aif\20@function.inner\aic\17@class.inner\aac\17@class.outer\1\0\5\venable\2\fkeymaps\0\14lookahead\2#include_surrounding_whitespace\2\20selection_modes\0\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rust-tools.nvim"] = {
    config = { "\27LJ\2\n∏\2\0\0\b\1\17\0\0216\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\6\0005\4\4\0005\5\3\0=\5\5\4=\4\a\0035\4\b\0-\5\0\0=\5\t\0045\5\r\0005\6\v\0005\a\n\0=\a\f\6=\6\14\5=\5\15\4=\4\16\3B\1\2\1K\0\1\0\2¿\vserver\rsettings\18rust-analyzer\1\0\1\18rust-analyzer\0\16checkOnSave\1\0\1\16checkOnSave\0\1\0\1\fcommand\vclippy\14on_attach\1\0\2\rsettings\0\14on_attach\0\ntools\1\0\2\vserver\0\ntools\0\14runnables\1\0\1\14runnables\0\1\0\1\18use_telescope\2\nsetup\15rust-tools\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/kkharji/sqlite.lua"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n\28\0\0\1\0\1\0\0025\0\0\0L\0\2\0\1\2\0\0\r--hiddenT\1\0\4\1\4\0\a-\0\0\0009\0\0\0005\2\2\0003\3\1\0=\3\3\2B\0\2\1K\0\1\0\1¿\20additional_args\1\0\1\20additional_args\0\0\14live_grepì\t\1\0\a\0<\0n6\0\0\0'\2\1\0B\0\2\0029\0\2\0006\1\0\0'\3\3\0B\1\2\0029\1\4\0015\3\15\0005\4\6\0005\5\5\0=\5\a\0045\5\n\0005\6\b\0=\0\t\6=\6\v\0055\6\f\0=\0\t\6=\6\r\5=\5\14\4=\4\16\3B\1\2\0016\1\0\0'\3\17\0B\1\2\0026\2\0\0'\4\18\0B\2\2\0029\3\19\2'\5\20\0009\6\21\1B\3\3\0019\3\19\2'\5\22\0009\6\23\1B\3\3\0019\3\19\2'\5\24\0009\6\25\1B\3\3\0019\3\19\2'\5\26\0003\6\27\0B\3\3\0019\3\19\2'\5\28\0009\6\29\1B\3\3\0019\3\19\2'\5\30\0009\6\31\1B\3\3\0019\3\19\2'\5 \0009\6!\1B\3\3\0019\3\19\2'\5\"\0009\6#\1B\3\3\0019\3\19\2'\5$\0009\6%\1B\3\3\0019\3\19\2'\5&\0009\6'\1B\3\3\0019\3\19\2'\5(\0009\6)\1B\3\3\0019\3\19\2'\5*\0009\6+\1B\3\3\0019\3\19\2'\5,\0009\6-\1B\3\3\0019\3\19\2'\5.\0009\6/\1B\3\3\0019\3\19\2'\0050\0009\0061\1B\3\3\0019\3\19\2'\0052\0009\0063\1B\3\3\0019\3\19\2'\0054\0009\0065\1B\3\3\0019\3\19\2'\0056\0009\0067\1B\3\3\0019\3\19\2'\0058\0009\0069\1B\3\3\0019\3\19\2'\5:\0009\6;\1B\3\3\0012\0\0ÄK\0\1\0\16diagnostics\15<Leader>fx\fkeymaps\22<Leader>f<Leader>\rjumplist\15<Leader>fj\18spell_suggest\15<Leader>fz\30current_buffer_fuzzy_find\14<Leader>/\vresume\15<Leader>fe\14registers\15<Leader>fy\16vim_options\15<Leader>fo\20quickfixhistory\15<Leader>fQ\rquickfix\15<Leader>fq\nmarks\15<Leader>fm\fpickers\15<Leader>fr\rcommands\15<Leader>fc\14help_tags\15<Leader>fh\fbuffers\15<Leader>fb\16grep_string\14<Leader>*\0\15<Leader>fG\14live_grep\15<Leader>fg\roldfiles\14<Leader>;\15find_files\14<Leader>'\nnbind\19user.functions\22telescope.builtin\rdefaults\1\0\1\rdefaults\0\rmappings\6n\1\0\1\n<c-t>\0\6i\1\0\2\6i\0\6n\0\n<c-t>\1\0\4\n<C-K>\28move_selection_previous\n<c-t>\0\n<C-J>\24move_selection_next\6;\19select_default\17cache_picker\1\0\2\rmappings\0\17cache_picker\0\1\0\1\16num_pickers\3 \nsetup\14telescope\topen\30trouble.sources.telescope\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "\27LJ\2\nW\0\1\5\0\5\0\b6\1\0\0'\3\1\0B\1\2\0029\1\2\1'\3\3\0005\4\4\0B\1\3\1K\0\1\0\1\0\1\vbuffer\2\n<Esc>\ftunbind\19user.functions\frequire<\0\0\3\0\5\1\a6\0\0\0009\0\1\0006\2\2\0009\2\3\0029\2\4\2\24\2\0\2D\0\2\0\fcolumns\6o\bvim\tceil\tmath\2:\0\0\3\0\5\1\a6\0\0\0009\0\1\0006\2\2\0009\2\3\0029\2\4\2\24\2\0\2D\0\2\0\nlines\6o\bvim\tceil\tmath\2$\0\0\3\1\1\0\5-\0\0\0\18\2\0\0009\0\0\0B\0\2\1K\0\1\0\2¿\vtoggleÒ\5\1\0\b\0 \00036\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0026\1\0\0'\3\4\0B\1\2\0029\1\5\1\18\4\1\0009\2\6\0015\5\a\0003\6\b\0=\6\t\0055\6\n\0003\a\v\0=\a\f\0063\a\r\0=\a\14\0065\a\15\0=\a\16\6=\6\17\5B\2\3\0023\3\18\0007\3\19\0009\3\20\0'\5\21\0'\6\22\0005\a\23\0B\3\4\0019\3\20\0'\5\24\0'\6\25\0B\3\3\0019\3\20\0'\5\26\0'\6\27\0B\3\3\0019\3\20\0'\5\28\0'\6\29\0B\3\3\0019\3\20\0'\5\30\0'\6\31\0B\3\3\0012\0\0ÄK\0\1\0):ToggleTerm direction=horizontal<CR>\15<leader>th':ToggleTerm direction=vertical<CR>\15<leader>tv$:ToggleTerm direction=float<CR>\15<leader>tf\":ToggleTerm direction=tab<CR>\15<leader>tt\1\0\2\fnoremap\2\vsilent\2#<cmd>lua _Lazygit_toggle()<CR>\15<leader>lg\nnbind\20_Lazygit_toggle\0\15float_opts\15highlights\1\0\2\vborder\16FloatBorder\15background\16NormalFloat\vheight\0\nwidth\0\1\0\5\nwidth\0\15highlights\0\vheight\0\rwinblend\3\0\vborder\vsingle\fon_open\0\1\0\5\14direction\nfloat\fon_open\0\vhidden\2\bcmd\flazygit\15float_opts\0\bnew\rTerminal\24toggleterm.terminal\19user.functions\nsetup\15toggleterm\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n≤\5\0\0\v\0\29\0=6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0015\0\3\0006\1\4\0\18\3\0\0B\1\2\4H\4\fÄ'\6\5\0\18\a\4\0&\6\a\0066\a\6\0009\a\a\a9\a\b\a\18\t\6\0005\n\t\0=\5\n\n=\6\v\n=\6\f\nB\a\3\1F\4\3\3R\4Ú\1276\1\0\0'\3\r\0B\1\2\0029\2\14\0019\2\15\0029\3\16\1'\5\17\0'\6\18\0\18\a\2\0B\3\4\0019\3\16\1'\5\19\0'\6\20\0\18\a\2\0B\3\4\0019\3\16\1'\5\21\0'\6\22\0\18\a\2\0B\3\4\0019\3\16\1'\5\23\0'\6\24\0\18\a\2\0B\3\4\0019\3\16\1'\5\25\0'\6\26\0\18\a\2\0B\3\4\0019\3\16\1'\5\27\0'\6\28\0\18\a\2\0B\3\4\1K\0\1\0$<cmd>Trouble lsp_references<cr>\agR#<cmd>Trouble qflist toggle<cr>\15<leader>xq$<cmd>Trouble loclist toggle<cr>\15<leader>xl*<cmd>Trouble document_diagnostics<cr>\15<leader>xd+<cmd>Trouble workspace_diagnostics<cr>\15<leader>xw\21<cmd>Trouble<cr>\15<leader>xx\nnbind\vsilent\rbind_opt\19user.functions\nnumhl\vtexthl\ttext\1\0\3\vtexthl\0\nnumhl\0\ttext\0\16sign_define\afn\bvim\19DiagnosticSign\npairs\1\0\4\tHint\tÔ†µ \nError\tÔôô \16Information\tÔëâ \tWarn\tÔî© \nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-interestingwords"] = {
    config = { "\27LJ\2\n¥\1\0\0\6\0\t\0\0166\0\0\0'\2\1\0B\0\2\0029\1\2\0'\3\3\0'\4\4\0009\5\5\0009\5\6\5B\1\4\0019\1\2\0'\3\a\0'\4\b\0009\5\5\0009\5\6\5B\1\4\1K\0\1\0\":call WordNavigation(0)<CR>zz\6N\vsilent\rbind_opt\":call WordNavigation(1)<CR>zz\6n\nnbind\19user.functions\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/vim-interestingwords",
    url = "https://github.com/lfv89/vim-interestingwords"
  },
  ["vim-sensible"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/vim-sensible",
    url = "https://github.com/tpope/vim-sensible"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/vim-snippets",
    url = "https://github.com/honza/vim-snippets"
  },
  ["zen-mode.nvim"] = {
    config = { "\27LJ\2\n1\0\1\4\0\3\0\0056\1\0\0009\1\1\1'\3\2\0B\1\2\1K\0\1\0\18ScrollbarHide\bcmd\bvim1\0\1\4\0\3\0\0056\1\0\0009\1\1\1'\3\2\0B\1\2\1K\0\1\0\18ScrollbarShow\bcmd\bvim«\1\1\0\5\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\0023\3\b\0=\3\t\0023\3\n\0=\3\v\2B\0\2\1K\0\1\0\ron_close\0\fon_open\0\vwindow\1\0\3\vwindow\0\fon_open\0\ron_close\0\foptions\1\0\2\15signcolumn\ano\vnumber\1\1\0\2\nwidth\3z\foptions\0\nsetup\rzen-mode\frequire\0" },
    loaded = true,
    path = "/Users/heath.farrow/.local/share/nvim/site/pack/packer/start/zen-mode.nvim",
    url = "https://github.com/folke/zen-mode.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-hlslens
time([[Config for nvim-hlslens]], true)
try_loadstring("\27LJ\2\nÒ\5\0\0\a\0\21\00036\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0015\0\4\0006\1\0\0'\3\5\0B\1\2\0029\2\6\1'\4\a\0'\5\b\0\18\6\0\0B\2\4\0019\2\6\1'\4\t\0'\5\n\0\18\6\0\0B\2\4\0019\2\6\1'\4\v\0'\5\f\0\18\6\0\0B\2\4\0019\2\6\1'\4\r\0'\5\14\0\18\6\0\0B\2\4\0019\2\6\1'\4\15\0'\5\16\0\18\6\0\0B\2\4\0019\2\6\1'\4\17\0'\5\18\0\18\6\0\0B\2\4\0019\2\6\1'\4\19\0'\5\20\0\18\6\0\0B\2\4\1K\0\1\0\17<Cmd>noh<CR>\14<Leader>l.g#<Cmd>lua require('hlslens').start()<CR>\ag#.g*<Cmd>lua require('hlslens').start()<CR>\ag*-#<Cmd>lua require('hlslens').start()<CR>\6#y:let stay_star_view = winsaveview()<CR>*<Cmd>lua require('hlslens').start()<CR>:call winrestview(stay_star_view)<cr>\6*[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zz\6N[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zz\6n\nnbind\19user.functions\1\0\2\fnoremap\2\vsilent\2\30scrollbar.handlers.search\nsetup\fhlslens\frequire\0", "config", "nvim-hlslens")
time([[Config for nvim-hlslens]], false)
-- Config for: barbar.nvim
time([[Config for barbar.nvim]], true)
try_loadstring("\27LJ\2\nA\0\0\3\0\4\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\3\0L\0\2\0\nwidth\tView\19nvim-tree.view\frequire.\0\0\4\2\1\0\6-\0\0\0009\0\0\0-\2\1\0B\2\1\0A\0\0\1K\0\1\0\1¿\2¿\15set_offset.\0\0\4\2\1\0\6-\0\0\0009\0\0\0-\2\1\0B\2\1\0A\0\0\1K\0\1\0\1¿\2¿\15set_offset(\0\0\3\1\1\0\5-\0\0\0009\0\0\0)\2\0\0B\0\2\1K\0\1\0\1¿\15set_offset™\r\1\0\n\0L\0ß\0016\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\0034\4\0\0166\5\a\0009\5\b\0059\5\t\0059\5\n\0055\6\v\0<\6\5\0046\5\a\0009\5\b\0059\5\t\0059\5\f\0055\6\r\0<\6\5\0046\5\a\0009\5\b\0059\5\t\0059\5\14\0055\6\15\0<\6\5\0046\5\a\0009\5\b\0059\5\t\0059\5\16\0055\6\17\0<\6\5\4=\4\18\3=\3\19\2B\0\2\0016\0\0\0'\2\20\0B\0\2\0026\1\0\0'\3\21\0B\1\2\0023\2\22\0009\3\23\0'\5\24\0003\6\25\0B\3\3\0019\3\23\0'\5\26\0003\6\27\0B\3\3\0019\3\23\0'\5\28\0003\6\29\0B\3\3\0016\3\0\0'\5\30\0B\3\2\0029\4\31\0039\4 \0049\5!\3'\a\"\0'\b#\0\18\t\4\0B\5\4\0019\5!\3'\a$\0'\b%\0\18\t\4\0B\5\4\0019\5!\3'\a&\0'\b'\0\18\t\4\0B\5\4\0019\5!\3'\a(\0'\b)\0\18\t\4\0B\5\4\0019\5!\3'\a*\0'\b+\0\18\t\4\0B\5\4\0019\5!\3'\a,\0'\b-\0\18\t\4\0B\5\4\0019\5!\3'\a.\0'\b/\0\18\t\4\0B\5\4\0019\5!\3'\a0\0'\b1\0\18\t\4\0B\5\4\0019\5!\3'\a2\0'\b3\0\18\t\4\0B\5\4\0019\5!\3'\a4\0'\b5\0\18\t\4\0B\5\4\0019\5!\3'\a6\0'\b7\0\18\t\4\0B\5\4\0019\5!\3'\a8\0'\b9\0\18\t\4\0B\5\4\0019\5!\3'\a:\0'\b;\0\18\t\4\0B\5\4\0019\5!\3'\a<\0'\b=\0\18\t\4\0B\5\4\0019\5!\3'\a>\0'\b?\0\18\t\4\0B\5\4\0019\5!\3'\a@\0'\bA\0\18\t\4\0B\5\4\0019\5!\3'\aB\0'\bC\0\18\t\4\0B\5\4\0019\5!\3'\aD\0'\bE\0\18\t\4\0B\5\4\0019\5!\3'\aF\0'\bG\0\18\t\4\0B\5\4\0019\5!\3'\aH\0'\bI\0\18\t\4\0B\5\4\0019\5!\3'\aJ\0'\bK\0\18\t\4\0B\5\4\0012\0\0ÄK\0\1\0'<Cmd>BufferOrderByWindowNumber<CR>\14<Space>bw#<Cmd>BufferOrderByLanguage<CR>\14<Space>bl$<Cmd>BufferOrderByDirectory<CR>\14<Space>bd'<Cmd>BufferOrderByBufferNumber<CR>\14<Space>bb\24<Cmd>BufferPick<CR>\n<C-p>\25<Cmd>BufferClose<CR>\n<A-c>\23<Cmd>BufferPin<CR>\n<A-p>\24<Cmd>BufferLast<CR>\n<A-0>\26<Cmd>BufferGoto 9<CR>\n<A-9>\26<Cmd>BufferGoto 8<CR>\n<A-8>\26<Cmd>BufferGoto 7<CR>\n<A-7>\26<Cmd>BufferGoto 6<CR>\n<A-6>\26<Cmd>BufferGoto 5<CR>\n<A-5>\26<Cmd>BufferGoto 4<CR>\n<A-4>\26<Cmd>BufferGoto 3<CR>\n<A-3>\26<Cmd>BufferGoto 2<CR>\n<A-2>\26<Cmd>BufferGoto 1<CR>\n<A-1>\28<Cmd>BufferMoveNext<CR>\n<A->> <Cmd>BufferMovePrevious<CR>\n<A-<>\24<Cmd>BufferNext<CR>\n<A-.>\28<Cmd>BufferPrevious<CR>\n<A-,>\nnbind\vsilent\rbind_opt\19user.functions\0\14TreeClose\0\vResize\0\rTreeOpen\14subscribe\0\19bufferline.api\21nvim-tree.events\nicons\16diagnostics\1\0\1\fenabled\1\tHINT\1\0\1\fenabled\1\tINFO\1\0\2\fenabled\2\ticon\bÔî©\tWARN\1\0\2\fenabled\2\ticon\bÔôô\nERROR\rseverity\15diagnostic\bvim\vpinned\1\0\2\vpinned\0\16diagnostics\0\1\0\1\vbutton\bÔ§Ç\1\0\5\20maximum_padding\3\1\nicons\0\rtabpages\2\19maximum_length\3\30\20minimum_padding\3\1\nsetup\15bufferline\frequire\0", "config", "barbar.nvim")
time([[Config for barbar.nvim]], false)
-- Config for: diffview.nvim
time([[Config for diffview.nvim]], true)
try_loadstring("\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0", "config", "diffview.nvim")
time([[Config for diffview.nvim]], false)
-- Config for: rust-tools.nvim
time([[Config for rust-tools.nvim]], true)
try_loadstring("\27LJ\2\n∏\2\0\0\b\1\17\0\0216\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\6\0005\4\4\0005\5\3\0=\5\5\4=\4\a\0035\4\b\0-\5\0\0=\5\t\0045\5\r\0005\6\v\0005\a\n\0=\a\f\6=\6\14\5=\5\15\4=\4\16\3B\1\2\1K\0\1\0\2¿\vserver\rsettings\18rust-analyzer\1\0\1\18rust-analyzer\0\16checkOnSave\1\0\1\16checkOnSave\0\1\0\1\fcommand\vclippy\14on_attach\1\0\2\rsettings\0\14on_attach\0\ntools\1\0\2\vserver\0\ntools\0\14runnables\1\0\1\14runnables\0\1\0\1\18use_telescope\2\nsetup\15rust-tools\frequire\0", "config", "rust-tools.nvim")
time([[Config for rust-tools.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nê\1\0\2\t\0\a\1\21*\2\0\0006\3\0\0006\5\1\0009\5\2\0059\5\3\0056\6\1\0009\6\4\0069\6\5\6\18\b\1\0B\6\2\0A\3\1\3\15\0\3\0X\5\aÄ\15\0\4\0X\5\5Ä9\5\6\4\1\2\5\0X\5\2Ä+\5\2\0L\5\2\0K\0\1\0\tsize\22nvim_buf_get_name\bapi\ffs_stat\tloop\bvim\npcallÄ¿\fà\2\1\0\5\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0003\4\5\0=\4\6\3=\3\a\0025\3\b\0=\3\t\0025\3\n\0=\3\v\2B\0\2\1K\0\1\0\frainbow\1\0\3\venable\2\18extended_mode\2\19max_file_lines\0\vindent\1\0\1\venable\2\14highlight\fdisable\0\1\0\2\venable\2\fdisable\0\1\0\4\vindent\0\frainbow\0\21ensure_installed\ball\14highlight\0\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n\28\0\0\1\0\1\0\0025\0\0\0L\0\2\0\1\2\0\0\r--hiddenT\1\0\4\1\4\0\a-\0\0\0009\0\0\0005\2\2\0003\3\1\0=\3\3\2B\0\2\1K\0\1\0\1¿\20additional_args\1\0\1\20additional_args\0\0\14live_grepì\t\1\0\a\0<\0n6\0\0\0'\2\1\0B\0\2\0029\0\2\0006\1\0\0'\3\3\0B\1\2\0029\1\4\0015\3\15\0005\4\6\0005\5\5\0=\5\a\0045\5\n\0005\6\b\0=\0\t\6=\6\v\0055\6\f\0=\0\t\6=\6\r\5=\5\14\4=\4\16\3B\1\2\0016\1\0\0'\3\17\0B\1\2\0026\2\0\0'\4\18\0B\2\2\0029\3\19\2'\5\20\0009\6\21\1B\3\3\0019\3\19\2'\5\22\0009\6\23\1B\3\3\0019\3\19\2'\5\24\0009\6\25\1B\3\3\0019\3\19\2'\5\26\0003\6\27\0B\3\3\0019\3\19\2'\5\28\0009\6\29\1B\3\3\0019\3\19\2'\5\30\0009\6\31\1B\3\3\0019\3\19\2'\5 \0009\6!\1B\3\3\0019\3\19\2'\5\"\0009\6#\1B\3\3\0019\3\19\2'\5$\0009\6%\1B\3\3\0019\3\19\2'\5&\0009\6'\1B\3\3\0019\3\19\2'\5(\0009\6)\1B\3\3\0019\3\19\2'\5*\0009\6+\1B\3\3\0019\3\19\2'\5,\0009\6-\1B\3\3\0019\3\19\2'\5.\0009\6/\1B\3\3\0019\3\19\2'\0050\0009\0061\1B\3\3\0019\3\19\2'\0052\0009\0063\1B\3\3\0019\3\19\2'\0054\0009\0065\1B\3\3\0019\3\19\2'\0056\0009\0067\1B\3\3\0019\3\19\2'\0058\0009\0069\1B\3\3\0019\3\19\2'\5:\0009\6;\1B\3\3\0012\0\0ÄK\0\1\0\16diagnostics\15<Leader>fx\fkeymaps\22<Leader>f<Leader>\rjumplist\15<Leader>fj\18spell_suggest\15<Leader>fz\30current_buffer_fuzzy_find\14<Leader>/\vresume\15<Leader>fe\14registers\15<Leader>fy\16vim_options\15<Leader>fo\20quickfixhistory\15<Leader>fQ\rquickfix\15<Leader>fq\nmarks\15<Leader>fm\fpickers\15<Leader>fr\rcommands\15<Leader>fc\14help_tags\15<Leader>fh\fbuffers\15<Leader>fb\16grep_string\14<Leader>*\0\15<Leader>fG\14live_grep\15<Leader>fg\roldfiles\14<Leader>;\15find_files\14<Leader>'\nnbind\19user.functions\22telescope.builtin\rdefaults\1\0\1\rdefaults\0\rmappings\6n\1\0\1\n<c-t>\0\6i\1\0\2\6i\0\6n\0\n<c-t>\1\0\4\n<C-K>\28move_selection_previous\n<c-t>\0\n<C-J>\24move_selection_next\6;\19select_default\17cache_picker\1\0\2\rmappings\0\17cache_picker\0\1\0\1\16num_pickers\3 \nsetup\14telescope\topen\30trouble.sources.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-treesitter-textobjects
time([[Config for nvim-treesitter-textobjects]], true)
try_loadstring("\27LJ\2\n¥\a\0\0\6\0\28\0\0316\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\26\0005\3\b\0005\4\3\0005\5\4\0=\5\5\0045\5\6\0=\5\a\4=\4\t\0035\4\n\0005\5\v\0=\5\f\0045\5\r\0=\5\14\4=\4\15\0035\4\16\0005\5\17\0=\5\18\0045\5\19\0=\5\20\0045\5\21\0=\5\22\0045\5\23\0=\5\24\4=\4\25\3=\3\27\2B\0\2\1K\0\1\0\16textobjects\1\0\1\16textobjects\0\tmove\22goto_previous_end\1\0\2\a[]\17@class.outer\a[M\20@function.outer\24goto_previous_start\1\0\2\a[[\17@class.outer\a[m\20@function.outer\18goto_next_end\1\0\2\a]M\20@function.outer\a][\17@class.outer\20goto_next_start\1\0\2\a]m\20@function.outer\a]]\17@class.outer\1\0\6\venable\2\24goto_previous_start\0\22goto_previous_end\0\18goto_next_end\0\20goto_next_start\0\14set_jumps\2\tswap\18swap_previous\1\0\1\14<leader>S\21@parameter.inner\14swap_next\1\0\1\14<leader>s\21@parameter.inner\1\0\3\venable\2\18swap_previous\0\14swap_next\0\vselect\1\0\3\tmove\0\vselect\0\tswap\0\20selection_modes\1\0\3\20@function.outer\6V\21@parameter.outer\6v\17@class.outer\n<C-v>\fkeymaps\1\0\6\aia\21@parameter.inner\aaf\20@function.outer\aaa\21@parameter.outer\aif\20@function.inner\aic\17@class.inner\aac\17@class.outer\1\0\5\venable\2\fkeymaps\0\14lookahead\2#include_surrounding_whitespace\2\20selection_modes\0\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter-textobjects")
time([[Config for nvim-treesitter-textobjects]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\nÓ\1\0\0\b\0\t\2'6\0\0\0\14\0\0\0X\1\2Ä6\0\1\0009\0\0\0007\0\0\0006\0\0\0006\2\2\0009\2\3\0029\2\4\2)\4\0\0B\2\2\0A\0\0\3\b\1\0\0X\2\20Ä6\2\2\0009\2\3\0029\2\5\2)\4\0\0\23\5\1\0\18\6\0\0+\a\2\0B\2\5\2:\2\1\2\18\4\2\0009\2\6\2\18\5\1\0\18\6\1\0B\2\4\2\18\4\2\0009\2\a\2'\5\b\0B\2\3\2\n\2\0\0X\2\2Ä+\2\1\0X\3\1Ä+\2\2\0L\2\2\0\a%s\nmatch\bsub\23nvim_buf_get_lines\24nvim_win_get_cursor\bapi\bvim\ntable\vunpack\0\2C\0\1\4\0\4\0\a6\1\0\0'\3\1\0B\1\2\0029\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\15lsp_expand\fluasnip\frequireV\0\0\3\0\4\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0D\0\2\0\nspell\26in_treesitter_capture\23cmp.config.context\frequire≈\1\0\1\3\3\5\0\29-\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\1\1B\1\1\1X\1\19Ä-\1\1\0009\1\2\1B\1\1\2\15\0\1\0X\2\4Ä-\1\1\0009\1\3\1B\1\1\1X\1\nÄ-\1\2\0B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\4\1B\1\1\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\2¿\1¿\0¿\rcomplete\19expand_or_jump\23expand_or_jumpable\21select_next_item\fvisibleé\1\0\1\4\2\4\0\23-\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\1\1B\1\1\1X\1\rÄ-\1\1\0009\1\2\1)\3ˇˇB\1\2\2\15\0\1\0X\2\5Ä-\1\1\0009\1\3\1)\3ˇˇB\1\2\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\2¿\1¿\tjump\rjumpable\21select_prev_item\fvisible˛\a\1\0\r\0004\0o6\0\0\0009\0\1\0'\1\3\0=\1\2\0003\0\4\0006\1\5\0'\3\6\0B\1\2\0026\2\5\0'\4\a\0B\2\2\0029\3\b\0025\5\f\0005\6\n\0003\a\t\0=\a\v\6=\6\r\0059\6\14\0029\6\15\0064\b\4\0005\t\16\0>\t\1\b5\t\17\0>\t\2\b5\t\18\0005\n\19\0003\v\20\0=\v\21\n=\n\22\t>\t\3\b4\t\3\0005\n\23\0>\n\1\tB\6\3\2=\6\15\0059\6\24\0029\6\25\0069\6\26\0065\b\28\0009\t\24\0029\t\27\t)\v¸ˇB\t\2\2=\t\29\b9\t\24\0029\t\27\t)\v\4\0B\t\2\2=\t\30\b9\t\24\0029\t\31\tB\t\1\2=\t \b9\t\24\0029\t!\tB\t\1\2=\t\"\b9\t\24\0029\t#\t5\v$\0B\t\2\2=\t%\b9\t\24\0023\v&\0005\f'\0B\t\3\2=\t(\b9\t\24\0023\v)\0005\f*\0B\t\3\2=\t+\bB\6\2\2=\6\24\5B\3\2\0019\3\b\0029\3,\0035\5-\0005\6.\0009\a\24\0029\a\25\a9\a,\aB\a\1\2=\a\24\0064\a\3\0005\b/\0>\b\1\a=\a\15\6B\3\3\0019\3\b\0029\3,\3'\0050\0005\0061\0009\a\24\0029\a\25\a9\a,\aB\a\1\2=\a\24\0069\a\14\0029\a\15\a4\t\3\0005\n2\0>\n\1\t4\n\3\0005\v3\0>\v\1\nB\a\3\2=\a\15\6B\3\3\0012\0\0ÄK\0\1\0\1\0\1\tname\fcmdline\1\0\1\tname\tpath\1\0\2\fsources\0\fmapping\0\6:\1\0\1\tname\vbuffer\1\0\2\fsources\0\fmapping\0\1\3\0\0\6/\6?\fcmdline\f<S-Tab>\1\3\0\0\6i\6s\0\n<Tab>\1\3\0\0\6i\6s\0\t<CR>\1\0\1\vselect\2\fconfirm\n<C-e>\nabort\14<C-Space>\rcomplete\n<C-f>\n<C-b>\1\0\a\14<C-Space>\0\n<C-f>\0\n<Tab>\0\n<C-b>\0\t<CR>\0\f<S-Tab>\0\n<C-e>\0\16scroll_docs\vinsert\vpreset\fmapping\1\0\1\tname\vbuffer\voption\22enable_in_context\0\1\0\2\22enable_in_context\0\21keep_all_entries\1\1\0\2\voption\0\tname\nspell\1\0\1\tname\fluasnip\1\0\1\tname\rnvim_lsp\fsources\vconfig\fsnippet\1\0\3\fsources\0\fmapping\0\fsnippet\0\vexpand\1\0\1\vexpand\0\0\nsetup\bcmp\fluasnip\frequire\0\26menu,menuone,noselect\16completeopt\bopt\bvim\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\nÇ\2\0\0\b\0\f\0\0226\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\0016\0\0\0'\2\6\0B\0\2\0026\1\0\0'\3\a\0B\1\2\0029\2\b\1\18\4\2\0009\2\t\2'\5\n\0009\6\v\0B\6\1\0A\2\2\1K\0\1\0\20on_confirm_done\17confirm_done\aon\nevent\bcmp\"nvim-autopairs.completion.cmp\21disable_filetype\1\0\1\21disable_filetype\0\1\3\0\0\20TelescopePrompt\bvim\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\nä\1\0\0\5\0\a\0\0146\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0016\0\0\0'\2\3\0B\0\2\0029\1\4\0'\3\5\0'\4\6\0B\1\3\1K\0\1\0\24:NvimTreeToggle<CR>\14<Leader>y\nnbind\19user.functions\nsetup\14nvim-tree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: cmp-nvim-lsp
time([[Config for cmp-nvim-lsp]], true)
try_loadstring("\27LJ\2\nB\0\0\3\0\4\0\0066\0\0\0009\0\1\0009\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\nfloat\1\14goto_prev\15diagnostic\bvimB\0\0\3\0\4\0\0066\0\0\0009\0\1\0009\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\nfloat\1\14goto_next\15diagnostic\bvim®\t\1\0\r\1/\1^6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0025\1\3\0006\2\0\0'\4\4\0B\2\2\0029\3\5\2'\5\6\0003\6\a\0\18\a\1\0B\3\4\0019\3\5\2'\5\b\0003\6\t\0\18\a\1\0B\3\4\0016\3\0\0'\5\n\0B\3\2\0029\3\v\0039\3\f\0035\5\18\0005\6\r\0006\a\14\0006\t\15\0009\t\16\t9\t\17\tB\t\1\0A\a\0\0?\a\0\0=\6\19\5B\3\2\0016\3\0\0'\5\n\0B\3\2\0029\3\20\0039\3\f\0035\5\21\0=\0\22\5-\6\0\0=\6\23\5B\3\2\0016\3\0\0'\5\n\0B\3\2\0029\3\24\0039\3\f\0035\5\25\0=\0\22\5-\6\0\0=\6\23\5B\3\2\0016\3\0\0'\5\n\0B\3\2\0029\3\26\0039\3\f\0035\5\27\0=\0\22\5-\6\0\0=\6\23\0055\6+\0005\a\29\0005\b\28\0=\b\30\a5\b \0005\t\31\0=\t!\b=\b\"\a5\b&\0006\t\15\0009\t#\t9\t$\t'\v%\0+\f\2\0B\t\3\2=\t'\b=\b(\a5\b)\0=\b*\a=\a,\6=\6-\5B\3\2\0016\3\0\0'\5\n\0B\3\2\0029\3.\0039\3\f\0034\5\0\0B\3\2\1K\0\1\0\2¿\vyamlls\rsettings\bLua\1\0\1\bLua\0\14telemetry\1\0\1\venable\1\14workspace\flibrary\1\0\2\flibrary\0\20checkThirdParty\1\5\26nvim_get_runtime_file\bapi\16diagnostics\fglobals\1\0\1\fglobals\0\1\2\0\0\bvim\fruntime\1\0\4\14workspace\0\fruntime\0\14telemetry\0\16diagnostics\0\1\0\1\fversion\vLuaJIT\1\0\3\rsettings\0\17capabilities\0\14on_attach\0\16sumneko_lua\1\0\2\17capabilities\0\14on_attach\0\fpyright\14on_attach\17capabilities\1\0\2\17capabilities\0\14on_attach\0\vbashls\bcmd\1\0\b\28sdk_include_prereleases\2\29enable_import_completion\1\31organize_imports_on_format\1\bcmd\0,enable_ms_build_load_projects_on_demand\1 enable_editorconfig_support\2\28enable_roslyn_analyzers\1 analyze_open_documents_only\1\vgetpid\afn\bvim\rtostring\1\4\0\0'/home/hfarrow/.local/omnisharp/run\21--languageserver\14--hostPID\nsetup\14omnisharp\14lspconfig\0\a]x\0\a[x\nnbind\19user.functions\1\0\2\fnoremap\2\vsilent\2\25default_capabilities\17cmp_nvim_lsp\frequire\tÄÄ¿ô\4\0", "config", "cmp-nvim-lsp")
time([[Config for cmp-nvim-lsp]], false)
-- Config for: nvim-surround
time([[Config for nvim-surround]], true)
try_loadstring("\27LJ\2\nÍ\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\fkeymaps\1\0\1\fkeymaps\0\1\0\n\16insert_line\vgC-ggZ\vdelete\bgzd\16visual_line\agZ\vvisual\agz\20normal_cur_line\bgZZ\16normal_line\bgzz\15normal_cur\agZ\vnormal\agz\vinsert\v<C-g>z\vchange\bgzc\nsetup\18nvim-surround\frequire\0", "config", "nvim-surround")
time([[Config for nvim-surround]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: lsp_lines.nvim
time([[Config for lsp_lines.nvim]], true)
try_loadstring("\27LJ\2\nö\1\0\0\4\1\b\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\3\0009\0\4\0009\0\5\0005\2\6\0-\3\0\0\19\3\3\0=\3\a\2B\0\2\1-\0\0\0\19\0\0\0.\0\0\0K\0\1\0\0\0\17virtual_text\1\0\1\17virtual_text\0\vconfig\15diagnostic\bvim\vtoggle\14lsp_lines\frequireü\1\0\0\5\1\a\0\0146\0\0\0009\0\1\0009\0\2\0005\2\5\0005\3\3\0-\4\0\0\19\4\4\0=\4\4\3=\3\6\2B\0\2\1-\0\0\0\19\0\0\0.\0\0\0K\0\1\0\1\0\18virtual_lines\1\0\1\18virtual_lines\0\22only_current_line\1\0\1\22only_current_line\0\vconfig\15diagnostic\bvim∫\2\1\0\b\2\15\0\0266\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\3\0009\0\4\0009\0\5\0005\2\6\0B\0\2\0013\0\a\0003\1\b\0006\2\0\0'\4\t\0B\2\2\0029\3\n\2'\5\v\0\18\6\0\0005\a\f\0B\3\4\0019\3\n\2'\5\r\0\18\6\1\0005\a\14\0B\3\4\1K\0\1\0\0\0\1\0\1\0\1\tdesc-Toggle virtual_lines - current line only\15<Leader>uX\1\0\1\tdesc&Toggle lsp_lines and virtual_text\15<Leader>ux\nnbind\19user.functions\0\0\1\0\1\17virtual_text\1\vconfig\15diagnostic\bvim\nsetup\14lsp_lines\frequire\0", "config", "lsp_lines.nvim")
time([[Config for lsp_lines.nvim]], false)
-- Config for: vim-interestingwords
time([[Config for vim-interestingwords]], true)
try_loadstring("\27LJ\2\n¥\1\0\0\6\0\t\0\0166\0\0\0'\2\1\0B\0\2\0029\1\2\0'\3\3\0'\4\4\0009\5\5\0009\5\6\5B\1\4\0019\1\2\0'\3\a\0'\4\b\0009\5\5\0009\5\6\5B\1\4\1K\0\1\0\":call WordNavigation(0)<CR>zz\6N\vsilent\rbind_opt\":call WordNavigation(1)<CR>zz\6n\nnbind\19user.functions\frequire\0", "config", "vim-interestingwords")
time([[Config for vim-interestingwords]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\nf\0\0\3\0\4\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0 scrollbar.handlers.gitsigns\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\no\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\foptions\1\0\1\foptions\0\1\0\1\ntheme\21gruvbox-material\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: glow.nvim
time([[Config for glow.nvim]], true)
try_loadstring("\27LJ\2\nÃ\1\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\t\14glow_path\18/usr/bin/glow\vheight\3Ë\a\vborder\vshadow\17height_ratio\4Õô≥Ê\fÃô≥ˇ\3\16width_ratio\4ÊÃô≥\6ÊÃôˇ\3\npager\1\nstyle\tdark\nwidth\3x\17install_path\17~/.local/bin\nsetup\tglow\frequire\0", "config", "glow.nvim")
time([[Config for glow.nvim]], false)
-- Config for: toggleterm.nvim
time([[Config for toggleterm.nvim]], true)
try_loadstring("\27LJ\2\nW\0\1\5\0\5\0\b6\1\0\0'\3\1\0B\1\2\0029\1\2\1'\3\3\0005\4\4\0B\1\3\1K\0\1\0\1\0\1\vbuffer\2\n<Esc>\ftunbind\19user.functions\frequire<\0\0\3\0\5\1\a6\0\0\0009\0\1\0006\2\2\0009\2\3\0029\2\4\2\24\2\0\2D\0\2\0\fcolumns\6o\bvim\tceil\tmath\2:\0\0\3\0\5\1\a6\0\0\0009\0\1\0006\2\2\0009\2\3\0029\2\4\2\24\2\0\2D\0\2\0\nlines\6o\bvim\tceil\tmath\2$\0\0\3\1\1\0\5-\0\0\0\18\2\0\0009\0\0\0B\0\2\1K\0\1\0\2¿\vtoggleÒ\5\1\0\b\0 \00036\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0026\1\0\0'\3\4\0B\1\2\0029\1\5\1\18\4\1\0009\2\6\0015\5\a\0003\6\b\0=\6\t\0055\6\n\0003\a\v\0=\a\f\0063\a\r\0=\a\14\0065\a\15\0=\a\16\6=\6\17\5B\2\3\0023\3\18\0007\3\19\0009\3\20\0'\5\21\0'\6\22\0005\a\23\0B\3\4\0019\3\20\0'\5\24\0'\6\25\0B\3\3\0019\3\20\0'\5\26\0'\6\27\0B\3\3\0019\3\20\0'\5\28\0'\6\29\0B\3\3\0019\3\20\0'\5\30\0'\6\31\0B\3\3\0012\0\0ÄK\0\1\0):ToggleTerm direction=horizontal<CR>\15<leader>th':ToggleTerm direction=vertical<CR>\15<leader>tv$:ToggleTerm direction=float<CR>\15<leader>tf\":ToggleTerm direction=tab<CR>\15<leader>tt\1\0\2\fnoremap\2\vsilent\2#<cmd>lua _Lazygit_toggle()<CR>\15<leader>lg\nnbind\20_Lazygit_toggle\0\15float_opts\15highlights\1\0\2\vborder\16FloatBorder\15background\16NormalFloat\vheight\0\nwidth\0\1\0\5\nwidth\0\15highlights\0\vheight\0\rwinblend\3\0\vborder\vsingle\fon_open\0\1\0\5\14direction\nfloat\fon_open\0\vhidden\2\bcmd\flazygit\15float_opts\0\bnew\rTerminal\24toggleterm.terminal\19user.functions\nsetup\15toggleterm\frequire\0", "config", "toggleterm.nvim")
time([[Config for toggleterm.nvim]], false)
-- Config for: nvim-scrollbar
time([[Config for nvim-scrollbar]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14scrollbar\frequire\0", "config", "nvim-scrollbar")
time([[Config for nvim-scrollbar]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
try_loadstring("\27LJ\2\nO\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\14lazy_load\"luasnip.loaders.from_snipmate\frequire\0", "config", "LuaSnip")
time([[Config for LuaSnip]], false)
-- Config for: leap.nvim
time([[Config for leap.nvim]], true)
try_loadstring("\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25add_default_mappings\tleap\frequire\0", "config", "leap.nvim")
time([[Config for leap.nvim]], false)
-- Config for: nvim-neoclip.lua
time([[Config for nvim-neoclip.lua]], true)
try_loadstring("\27LJ\2\nÜ\4\0\0\a\0\22\0$6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\0016\0\0\0'\2\3\0B\0\2\0029\0\4\0005\2\5\0005\3\16\0005\4\b\0005\5\6\0004\6\0\0=\6\a\5=\5\t\0045\5\n\0005\6\v\0=\6\f\0055\6\r\0=\6\14\0054\6\0\0=\6\a\5=\5\15\4=\4\1\3=\3\17\2B\0\2\0016\0\0\0'\2\18\0B\0\2\0029\0\19\0'\2\20\0'\3\21\0B\0\3\1K\0\1\0\27:Telescope neoclip<CR>\15<Leader>fp\nnbind\19user.functions\tkeys\1\0\1\14telescope\0\6n\17paste_behind\1\3\0\0\6:\6P\npaste\1\3\0\0\6;\6p\1\0\6\vcustom\0\vdelete\6d\vselect\t<cr>\npaste\0\vreplay\6q\17paste_behind\0\6i\1\0\2\6i\0\6n\0\vcustom\1\0\6\vcustom\0\vdelete\n<c-d>\vselect\t<cr>\npaste\6;\vreplay\n<c-q>\17paste_behind\n<c-p>\1\0\3\20continuous_sync\2\30enable_persistent_history\2\tkeys\0\nsetup\fneoclip\19load_extension\14telescope\frequire\0", "config", "nvim-neoclip.lua")
time([[Config for nvim-neoclip.lua]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n≤\5\0\0\v\0\29\0=6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0015\0\3\0006\1\4\0\18\3\0\0B\1\2\4H\4\fÄ'\6\5\0\18\a\4\0&\6\a\0066\a\6\0009\a\a\a9\a\b\a\18\t\6\0005\n\t\0=\5\n\n=\6\v\n=\6\f\nB\a\3\1F\4\3\3R\4Ú\1276\1\0\0'\3\r\0B\1\2\0029\2\14\0019\2\15\0029\3\16\1'\5\17\0'\6\18\0\18\a\2\0B\3\4\0019\3\16\1'\5\19\0'\6\20\0\18\a\2\0B\3\4\0019\3\16\1'\5\21\0'\6\22\0\18\a\2\0B\3\4\0019\3\16\1'\5\23\0'\6\24\0\18\a\2\0B\3\4\0019\3\16\1'\5\25\0'\6\26\0\18\a\2\0B\3\4\0019\3\16\1'\5\27\0'\6\28\0\18\a\2\0B\3\4\1K\0\1\0$<cmd>Trouble lsp_references<cr>\agR#<cmd>Trouble qflist toggle<cr>\15<leader>xq$<cmd>Trouble loclist toggle<cr>\15<leader>xl*<cmd>Trouble document_diagnostics<cr>\15<leader>xd+<cmd>Trouble workspace_diagnostics<cr>\15<leader>xw\21<cmd>Trouble<cr>\15<leader>xx\nnbind\vsilent\rbind_opt\19user.functions\nnumhl\vtexthl\ttext\1\0\3\vtexthl\0\nnumhl\0\ttext\0\16sign_define\afn\bvim\19DiagnosticSign\npairs\1\0\4\tHint\tÔ†µ \nError\tÔôô \16Information\tÔëâ \tWarn\tÔî© \nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: zen-mode.nvim
time([[Config for zen-mode.nvim]], true)
try_loadstring("\27LJ\2\n1\0\1\4\0\3\0\0056\1\0\0009\1\1\1'\3\2\0B\1\2\1K\0\1\0\18ScrollbarHide\bcmd\bvim1\0\1\4\0\3\0\0056\1\0\0009\1\1\1'\3\2\0B\1\2\1K\0\1\0\18ScrollbarShow\bcmd\bvim«\1\1\0\5\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\0023\3\b\0=\3\t\0023\3\n\0=\3\v\2B\0\2\1K\0\1\0\ron_close\0\fon_open\0\vwindow\1\0\3\vwindow\0\fon_open\0\ron_close\0\foptions\1\0\2\15signcolumn\ano\vnumber\1\1\0\2\nwidth\3z\foptions\0\nsetup\rzen-mode\frequire\0", "config", "zen-mode.nvim")
time([[Config for zen-mode.nvim]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'dashboard-nvim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
