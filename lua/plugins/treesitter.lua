return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- Load query module first to initialize language mappings
      pcall(require, 'vim.treesitter.query')

      require('nvim-treesitter').setup({
        ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'javascript', 'vim', 'vimdoc' },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          disable = {},
        },
        indent = {
          enable = true,
        },
      })

      -- Enable treesitter-based highlighting and indentation for all filetypes
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- Incremental selection keymaps
      vim.keymap.set('n', '<c-space>', function()
        require('nvim-treesitter.incremental_selection').init_selection()
      end, { desc = 'Treesitter init selection' })
      vim.keymap.set('v', '<c-space>', function()
        require('nvim-treesitter.incremental_selection').node_incremental()
      end, { desc = 'Treesitter node incremental' })
      vim.keymap.set('v', '<c-s>', function()
        require('nvim-treesitter.incremental_selection').scope_incremental()
      end, { desc = 'Treesitter scope incremental' })
      vim.keymap.set('v', '<m-space>', function()
        require('nvim-treesitter.incremental_selection').node_decremental()
      end, { desc = 'Treesitter node decremental' })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })

      local select = require('nvim-treesitter-textobjects.select')
      local move = require('nvim-treesitter-textobjects.move')
      local swap = require('nvim-treesitter-textobjects.swap')

      -- Select textobjects
      local select_maps = {
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      }
      for key, query in pairs(select_maps) do
        vim.keymap.set({ 'x', 'o' }, key, function()
          select.select_textobject(query, 'textobjects')
        end, { desc = 'Select ' .. query })
      end

      -- Move to next/previous
      local move_maps = {
        [']m'] = { fn = move.goto_next_start, query = '@function.outer', desc = 'Next function start' },
        [']]'] = { fn = move.goto_next_start, query = '@class.outer', desc = 'Next class start' },
        [']M'] = { fn = move.goto_next_end, query = '@function.outer', desc = 'Next function end' },
        [']['] = { fn = move.goto_next_end, query = '@class.outer', desc = 'Next class end' },
        ['[m'] = { fn = move.goto_previous_start, query = '@function.outer', desc = 'Prev function start' },
        ['[['] = { fn = move.goto_previous_start, query = '@class.outer', desc = 'Prev class start' },
        ['[M'] = { fn = move.goto_previous_end, query = '@function.outer', desc = 'Prev function end' },
        ['[]'] = { fn = move.goto_previous_end, query = '@class.outer', desc = 'Prev class end' },
      }
      for key, map in pairs(move_maps) do
        vim.keymap.set({ 'n', 'x', 'o' }, key, function()
          map.fn(map.query, 'textobjects')
        end, { desc = map.desc })
      end

      -- Swap parameters
      vim.keymap.set('n', '<leader>a', function()
        swap.swap_next('@parameter.inner')
      end, { desc = 'Swap next parameter' })
      vim.keymap.set('n', '<leader>A', function()
        swap.swap_previous('@parameter.inner')
      end, { desc = 'Swap previous parameter' })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true,
      multiwindow = false,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = 'outer',
      mode = 'cursor',
      separator = nil,
      zindex = 20,
      on_attach = nil,
    },
  },
}
