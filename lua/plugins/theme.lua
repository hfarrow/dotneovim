return {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.gruvbox_material_foreground = 'material'
      vim.g.gruvbox_material_background = 'medium'
      vim.g.gruvbox_material_enable_bold = 1
    end,
    config = function() vim.cmd.colorscheme('gruvbox-material') end,
  },
}
