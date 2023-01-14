local fn = require('user.functions')
local autocmd = fn.autocmd_helper('markdown_local', { clear = true })
local s = vim.opt_local

s.spell = true
s.tabstop = 2
s.shiftwidth = 2
s.softtabstop = 2
s.formatoptions:append('w')

-- Wrap current word in a md link
fn.nbind('<BS>', "gziw]%a()<Left>", { remap = true })
fn.vbind('<BS>', 'gz]<Right>%%a()<Left>', { remap = true })

-- Auto-format the current paragraph. This simulates 'set fo+=a' which is not used because it
-- cmp was deleting surrounding words when a completion was executed.
-- TODO: This needs to be aware if you are editing YAML front matter
--[[ autocmd({ 'InsertLeave'}, {
  desc = "Auto-format paragraph ",
  command = ':normal! gwip'
}) ]]

local cmd_name_blog_img = 'BlogImg'
autocmd(
  { 'BufEnter' },
  {
    desc = "Enable blog specific commands and mappings",
    pattern = '*.md',
    callback = function()
      -- TODO: detect if inside blog? or turn blog_emded_img into generic markdown image util and pass directory to
      -- search as option?
      vim.api.nvim_buf_create_user_command(
        0,
        cmd_name_blog_img,
        function(_)
          require('user.functions').blog_pick_img()
        end,
        {}
      )
    end
  }
)
