return {
  {
    'pittcat/codex.nvim',
    config = function()
      require('codex').setup({
        terminal = {
          direction = 'vertical',
          size = 0.35,
        },
      })

      -- Keymaps with <leader>cx prefix (Codex equivalent of <leader>cc for Claude)
      -- cxo/cxb/cxl always ensure Codex is open first; cxt is the only toggle.
      vim.keymap.set('n', '<leader>cxo', '<cmd>CodexOpen<cr>', { desc = 'Open Codex' })
      vim.keymap.set('n', '<leader>cxt', '<cmd>CodexToggle<cr>', { desc = 'Toggle Codex terminal' })
      vim.keymap.set('n', '<leader>cxb', '<cmd>CodexOpen<cr><cmd>CodexSendPath<cr>', { desc = 'Add current buffer to Codex' })
      vim.keymap.set('v', '<leader>cxl', ':<C-u>CodexOpen<cr>:CodexSendSelection<cr>', { desc = 'Send selection to Codex' })
    end,
  },
}
