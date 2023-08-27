-- Git-blame
vim.g.gitblame_enabled = 1
vim.g.gitblame_delay = 1000
vim.g.gitblame_date_format = '%r'
vim.g.gitblame_message_template = '> <author> • <date> • <summary> <'
vim.g.gitblame_message_when_not_committed = '> not commited <'
vim.g.gitblame_highlight_group = "Normal"
vim.g.gitblame_virtual_text_column =  40

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

vim.keymap.set( "n", "<leader>gg", ":G<CR>", { noremap = true, desc='Git summary' })
vim.keymap.set( "n", "<leader>gb", ":G blame<CR>", { noremap = true, desc='Git load diffs to quickfix list' })
vim.keymap.set( "n", "<leader>gdt", ":G difftool<CR>", { noremap = true, desc='Git load diffs to quickfix list' })
vim.keymap.set( "n", "<leader>gds", ":Gdiffsplit<CR>", { noremap = true, desc='Show git diff in split window' })

-- Browse is from netrw, but it's disabled by telescope, the following is used to get around that.
-- from https://vi.stackexchange.com/questions/38447/vim-fugitive-netrw-not-found-define-your-own-browse-to-use-gbrowse
vim.cmd([[command! -nargs=1 Browse silent execute '!xdg-open' shellescape(<q-args>,1)]])
