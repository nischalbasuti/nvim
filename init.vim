" indentation
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" navigation
set relativenumber
set scrolloff=4
set noerrorbells

" search
set ignorecase
set smartcase
set incsearch

" history
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

" buffers
set hidden

set signcolumn=yes
set colorcolumn=80

call plug#begin('~/.vim/plugged')
" Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'

Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'rhysd/conflict-marker.vim'

Plug 'tommcdo/vim-lion'
Plug 'jiangmiao/auto-pairs'
Plug 'docunext/closetag.vim'
Plug 'tpope/vim-commentary'

Plug 'thaerkh/vim-indentguides'
call plug#end()

let g:indentguides_spacechar = '⎸' " 'LEFT VERTICAL BOX LINE' (U+23B8)

colorscheme gruvbox
" highlight Normal guibg=none ctermbg=none

" cycle through splits
nnoremap <Tab><Tab> <C-w>=<C-w><C-w>
nnoremap <Tab>h <C-w><C-h>
nnoremap <Tab>l <C-w><C-l>
nnoremap <Tab>j <C-w><C-j>
nnoremap <Tab>k <C-w><C-k>

" make split occupy all vertical space
nnoremap <Tab><Leader> :vsp<CR>
" make split occupy all horizonal space
nnoremap <Tab>- :sp<CR>
" all splits occupy equal space
nnoremap <Tab>= <C-w>=


" common typos
command W w
command Wq wq
command WQ wq
command Q q
