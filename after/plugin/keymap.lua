-- cycle through splits
vim.api.nvim_set_keymap("n", "<Leader><Tab>", "<C-w>=<C-w><C-w>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>h", "<C-w><C-h>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>l", "<C-w><C-l>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>j", "<C-w><C-j>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>k", "<C-w><C-k>", {noremap = true})

-- copy current file path to system clipboard
vim.cmd([[map <leader>yf :let @+=expand("%")<CR>]])

-- system clipboard keymaps
vim.cmd[[
noremap <leader>y "+y
noremap <leader>yy "+y
noremap <Leader>p "+p
noremap <Leader>d "+d
]]

-- paste the last yank (so regualr p will paste the last delete or yank)
vim.cmd [[ noremap <Leader>0 "0p ]]

-- switch to last buffer
vim.keymap.set( "n", "<leader><Tab>", ":e #<CR>", { noremap = true, desc='Switch to last buffer' })

-- run formatter
vim.keymap.set( "n", "<leader>nf", ":Neoformat<CR>", { noremap = true, desc='run Neoformat' })
