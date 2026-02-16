return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'mocha',
      background = {
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = false,
      dim_inactive = {
        enabled = true,
        shade = 'dark',
        percentage = 0.25,
      },
      no_italic = false,
      no_bold = false,
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        loops = {},
        functions = { 'bold' },
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = {},
      integrations = {
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        mini = false,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end,
  },
}
