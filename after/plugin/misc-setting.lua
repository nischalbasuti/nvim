-- [[ Personal Preferences ]]

-- Enable smart indentation and tabs
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt.scrolloff = 4
vim.opt.termguicolors = true -- Enables highlight groups

-- Set language-specific tab preferences

-- [[ Setting options ]]

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]

-- Don't do anything when you hit space in normal mode and visual mode
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- support italics
vim.cmd [[
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
]]

-- Automatically source .zshrc on save
vim.cmd([[
  autocmd BufWritePost ~/.zshrc !source ~/.zshrc > /dev/null
]])

vim.opt.colorcolumn = "81,121"

-- Disable wrapping in quickfix window
vim.cmd([[
augroup QuickfixSettings
    autocmd!
    autocmd FileType qf setlocal nowrap
augroup END
]])
