return {
  {
    'neanias/everforest-nvim',
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('everforest').setup({
        background = 'hard',
        show_eob = false,
        dim_inactive_windows = true,
      })
    end,
  },
}
