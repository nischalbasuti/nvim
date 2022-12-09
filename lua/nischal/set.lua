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
