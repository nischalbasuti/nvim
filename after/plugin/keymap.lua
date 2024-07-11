-- cycle through splits
vim.api.nvim_set_keymap("n", "<Tab><Tab>", "<C-w>=<C-w><C-w>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Tab>h", "<C-w><C-h>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Tab>l", "<C-w><C-l>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Tab>j", "<C-w><C-j>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Tab>k", "<C-w><C-k>", {noremap = true})

-- make split occupy all vertical space
vim.api.nvim_set_keymap("n", "<Tab><Leader>", ":vsp<CR>", {noremap = true})
-- make split occupy all horizonal space
vim.api.nvim_set_keymap("n", "<Tab>-", ":sp<CR>", {noremap = true})
-- all splits occupy equal space
vim.api.nvim_set_keymap("n", "<Tab>=", "<C-w>=", {noremap = true})

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
