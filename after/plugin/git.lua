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

