return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged_enable = true,
      signcolumn = true,
      numhl = true,
      linehl = false,
      word_diff = false,
      watch_gitdir = { follow_files = true },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'right_align',
        delay = 100,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
    },
  },

  {
    'tpope/vim-fugitive',
    dependencies = { 'tpope/vim-rhubarb' },
    cmd = { 'G', 'Git', 'Gdiffsplit' },
    keys = {
      { '<leader>gg', ':G<CR>', desc = 'Git summary' },
      { '<leader>gb', ':G blame<CR>', desc = 'Git blame' },
      { '<leader>gd', ':G difftool<CR>', desc = 'Git difftool' },
      { '<leader>gs', ':Gdiffsplit<CR>', desc = 'Git diff split' },
      { '<leader>gaf', ':G add @%<CR>', desc = 'Git add current file' },
    },
    config = function()
      -- Browse workaround (netrw disabled)
      vim.cmd([[command! -nargs=1 Browse silent execute '!xdg-open' shellescape(<q-args>,1)]])
    end,
  },

  {
    'akinsho/git-conflict.nvim',
    version = '*',
    opts = {},
  },
}
