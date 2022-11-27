-- indentation
vim.cmd([[
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
]])

-- navigation
vim.cmd([[
set relativenumber
set scrolloff=4
set noerrorbells
]])

-- search
vim.cmd([[
set ignorecase
set smartcase
set incsearch
]])

-- history
vim.cmd([[
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
]])

-- buffers
vim.cmd([[
set hidden
]])

vim.cmd([[
set signcolumn=yes
set colorcolumn=80
]])

vim.cmd([[
call plug#begin('~/.vim/plugged')
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'

Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'rhysd/conflict-marker.vim'

Plug 'tommcdo/vim-lion'
Plug 'jiangmiao/auto-pairs'
Plug 'docunext/closetag.vim'
Plug 'tpope/vim-commentary'

Plug 'thaerkh/vim-indentguides'

Plug 'neovim/nvim-lspconfig'
call plug#end()
]])

-- let g:indentguides_spacechar = '⎸' -- 'LEFT VERTICAL BOX LINE' (U+23B8)
vim.g.indentguides_spacechar = '⎸'

vim.cmd('colorscheme gruvbox')

-- highlight Normal guibg=none ctermbg=none

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


-- common typos
vim.cmd([[
command W w
command Wq wq
command WQ wq
command Q q
]])
