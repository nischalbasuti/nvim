require('nischal')

vim.cmd([[
call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-t<leader>ffelescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-file-browser.nvim'

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

-- common typos
vim.cmd([[
command W w
command Wq wq
command WQ wq
command Q q
]])
