return {
  {
    'supermaven-inc/supermaven-nvim',
    opts = {
      keymaps = {
        accept_suggestion = '<C-l>',
      },
      log_level = 'info',
      disable_inline_completion = false,
      disable_keymaps = false,
      condition = function()
        return false
      end,
    },
  }
}
