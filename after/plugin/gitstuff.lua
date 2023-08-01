-- Git blamer
vim.g.blamer_enabled = 1
vim.g.blamer_delay = 500
vim.g.blamer_date_format = '20%y/%m/%d %H:%M'
vim.g.blamer_relative_time = 1
vim.g.blamer_show_in_visual_modes = 0
vim.g.blamer_prefix = ' > '

-- vim.cmd [[highlight Blamer guifg=lightgrey]]

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

