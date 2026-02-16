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
  },

  {
    'coder/claudecode.nvim',
    config = function()
      require('claudecode').setup({
        focus_after_send = false,
        terminal = {
          provider = 'none',
        },
      })

      -- Keymaps with <leader>cc prefix
      vim.keymap.set('n', '<C-t>', '<cmd>ClaudeCode<cr>', { desc = 'Toggle Claude' })
      vim.keymap.set('n', '<leader>ccf', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Focus Claude' })
      vim.keymap.set('n', '<leader>ccr', '<cmd>ClaudeCode --resume<cr>', { desc = 'Resume Claude session' })
      vim.keymap.set('n', '<leader>ccc', '<cmd>ClaudeCode --continue<cr>', { desc = 'Continue Claude session' })
      vim.keymap.set('n', '<leader>ccb', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Add current buffer to Claude' })
      vim.keymap.set('v', '<leader>ccl', '<cmd>ClaudeCodeSend<cr>', { desc = 'Send selection to Claude' })
      vim.keymap.set('n', '<leader>cca', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept diff changes' })
      vim.keymap.set('n', '<leader>ccd', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Deny diff changes' })
      vim.keymap.set('n', '<leader>ccx', '<cmd>ClaudeCodeStatus<cr>', { desc = 'Show Claude status' })

      -- Terminal mode keymaps
      vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
      vim.keymap.set('t', '<C-t>', '<cmd>ClaudeCode<cr>', { desc = 'Toggle Claude' })
      vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Move to left window' })
      vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Move to window below' })
      vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Move to window above' })
      vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Move to right window' })
    end,
  },
}
