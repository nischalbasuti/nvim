return {
  -- Oil file explorer
  {
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup({
        default_file_explorer = true,
        columns = { 'icon' },
        buf_options = {
          buflisted = false,
          bufhidden = 'hide',
        },
        win_options = {
          wrap = false,
          signcolumn = 'no',
          cursorcolumn = false,
          foldcolumn = '0',
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = 'nvic',
        },
        delete_to_trash = false,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-s>'] = 'actions.select_vsplit',
          ['<C-h>'] = 'actions.select_split',
          ['<C-t>'] = 'actions.select_tab',
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = 'actions.close',
          ['<C-l>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = 'actions.tcd',
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['g.'] = 'actions.toggle_hidden',
          ['g\\'] = 'actions.toggle_trash',
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = false,
          is_hidden_file = function(name, _bufnr)
            return vim.startswith(name, '.')
          end,
          is_always_hidden = function(_name, _bufnr)
            return false
          end,
          sort = {
            { 'type', 'asc' },
            { 'name', 'asc' },
          },
        },
        float = {
          padding = 2,
          max_width = 0,
          max_height = 0,
          border = 'rounded',
          win_options = { winblend = 0 },
          override = function(conf) return conf end,
        },
        preview = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = 0.9,
          min_height = { 5, 0.1 },
          height = nil,
          border = 'rounded',
          win_options = { winblend = 0 },
        },
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = 'rounded',
          minimized_border = 'none',
          win_options = { winblend = 0 },
        },
      })

      vim.keymap.set('n', '<leader>b', ':Oil<CR>', { noremap = true, desc = 'Oil file browser' })
    end,
  },

  -- nvim-tree
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      local HEIGHT_RATIO = 0.8
      local WIDTH_RATIO = 0.5

      local function on_attach(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        vim.keymap.set('n', 'n', api.fs.create, opts('New File'))
        vim.keymap.set('n', '<Esc>', ':NvimTreeClose<CR>', opts('Close'))
      end

      require('nvim-tree').setup({
        sort_by = 'case_sensitive',
        on_attach = on_attach,
        view = {
          float = {
            enable = true,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
              return {
                border = 'rounded',
                relative = 'editor',
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
          width = function()
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
          end,
        },
        renderer = { group_empty = true },
        filters = { dotfiles = true },
      })

      vim.keymap.set('n', '<leader>nt', ':NvimTreeFindFileToggle<CR>', { noremap = true, desc = '[N]vim [T]ree' })
    end,
  },

  -- Comment
  { 'numToStr/Comment.nvim', opts = {} },

  -- Indent blankline
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

  -- Illuminate
  {
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure({
        providers = { 'lsp', 'treesitter', 'regex' },
        delay = 100,
        filetype_overrides = {},
        filetypes_denylist = { 'dirbuf', 'dirvish', 'fugitive' },
        filetypes_allowlist = {},
        modes_denylist = {},
        modes_allowlist = {},
        providers_regex_syntax_denylist = {},
        providers_regex_syntax_allowlist = {},
        under_cursor = true,
        large_file_cutoff = 10000,
        large_file_overrides = nil,
        min_count_to_highlight = 1,
        should_enable = function(_bufnr) return true end,
        case_insensitive_regex = false,
        disable_keymaps = false,
      })
    end,
  },

  -- Auto-pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  -- Surround
  { 'tpope/vim-surround' },

  -- Matchup
  { 'andymass/vim-matchup' },

  -- Sleuth (detect tabstop/shiftwidth)
  { 'tpope/vim-sleuth' },
}
