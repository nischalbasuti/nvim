return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable('make') == 1 },
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'debugloop/telescope-undo.nvim',
      'nvim-telescope/telescope-dap.nvim',
    },
    event = 'VimEnter',
    config = function()
      require('telescope').setup({
        defaults = {
          layout_strategy = 'vertical',
          path_display = { 'truncate' },
          file_ignore_patterns = { 'node_modules' },
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
            n = {
              ['<C-d>'] = 'delete_buffer',
              ['<leader>q'] = function(prompt_bufnr)
                require('telescope.actions').send_to_qflist(prompt_bufnr)
                vim.cmd('copen')
              end,
            },
          },
        },
        extensions = {
          undo = {
            use_delta = true,
            use_custom_command = nil,
            side_by_side = true,
            vim_diff_opts = { ctxlen = 4 },
            entry_format = 'state #$ID, $STAT, $TIME',
            time_format = '',
            saved_only = false,
            layout_strategy = 'horizontal',
            layout_config = {
              preview_height = 0.8,
            },
            mappings = {
              i = {
                ['<cr>'] = require('telescope-undo.actions').yank_additions,
                ['<S-cr>'] = require('telescope-undo.actions').yank_deletions,
                ['<C-cr>'] = require('telescope-undo.actions').restore,
                ['<C-y>'] = require('telescope-undo.actions').yank_deletions,
                ['<C-r>'] = require('telescope-undo.actions').restore,
              },
              n = {
                ['y'] = require('telescope-undo.actions').yank_additions,
                ['Y'] = require('telescope-undo.actions').yank_deletions,
                ['u'] = require('telescope-undo.actions').restore,
              },
            },
          },
        },
      })

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'file_browser')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'undo')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>sr', builtin.oldfiles, { desc = '[S]earch [R]ecently opened files' })
      vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>tr', builtin.resume, { desc = '[T]elescope [R]esume' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sp', builtin.git_files, { desc = '[S]earch git [F]iles' })
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', ':Telescope keymaps<CR>', { noremap = true, desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>tb', ':Telescope file_browser<CR>', { noremap = true, desc = '[T]elescope file [B]rowser' })

      vim.keymap.set('n', '<leader>gb', ':Telescope git_branches<CR>', { noremap = true, desc = 'Git branches' })
      vim.keymap.set('n', '<leader>gc', ':Telescope git_commits<CR>', { noremap = true, desc = 'Git commits' })
      vim.keymap.set('n', '<leader>gst', ':Telescope git_status<CR>', { noremap = true, desc = 'Git status' })

      vim.keymap.set('n', '<leader>u', ':Telescope undo<CR>', { noremap = true, desc = '[U]ndo tree' })
      vim.keymap.set('v', '<leader>sw', '"zy:Telescope grep_string default_text=<C-r>z<cr>', { noremap = true, desc = '[S]earch [W]ords under visual selection' })
    end,
  },
}
