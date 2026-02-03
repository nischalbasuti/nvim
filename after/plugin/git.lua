require('gitsigns').setup {
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
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
    delay = 100,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
}

vim.keymap.set( "n", "<leader>gg", ":G<CR>", { noremap = true, desc='Git summary' })
vim.keymap.set( "n", "<leader>gb", ":G blame<CR>", { noremap = true, desc='Git load diffs to quickfix list' })
vim.keymap.set( "n", "<leader>gdt", ":G difftool<CR>", { noremap = true, desc='Git load diffs to quickfix list' })
vim.keymap.set( "n", "<leader>gdf", ":Gdiffsplit<CR>", { noremap = true, desc='Show git diff in split window' })
vim.keymap.set( "n", "<leader>gaf", ":G add @%<CR>", { noremap = true, desc='Show git diff in split window' })


-- Browse is from netrw, but it's disabled by telescope, the following is used to get around that.
-- from https://vi.stackexchange.com/questions/38447/vim-fugitive-netrw-not-found-define-your-own-browse-to-use-gbrowse
vim.cmd([[command! -nargs=1 Browse silent execute '!xdg-open' shellescape(<q-args>,1)]])
