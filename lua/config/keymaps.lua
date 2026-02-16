-- Keymaps (from after/plugin/keymap.lua, modernized)

-- Don't do anything when you hit space in normal/visual mode
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Split navigation
vim.keymap.set('n', '<leader>h', '<C-w><C-h>', { noremap = true, desc = 'Move to left split' })
vim.keymap.set('n', '<leader>l', '<C-w><C-l>', { noremap = true, desc = 'Move to right split' })
vim.keymap.set('n', '<leader>j', '<C-w><C-j>', { noremap = true, desc = 'Move to below split' })
vim.keymap.set('n', '<leader>k', '<C-w><C-k>', { noremap = true, desc = 'Move to above split' })

-- Copy current file path to system clipboard
vim.keymap.set('n', '<leader>yf', function()
  vim.fn.setreg('+', vim.fn.expand('%'))
end, { desc = 'Copy file path to clipboard' })

-- System clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { noremap = true, desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>yy', '"+y', { noremap = true, desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { noremap = true, desc = 'Paste from clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"+d', { noremap = true, desc = 'Delete to clipboard' })

-- Paste last yank (not last delete)
vim.keymap.set({ 'n', 'v' }, '<leader>0', '"0p', { noremap = true, desc = 'Paste last yank' })

-- Switch to last buffer
vim.keymap.set('n', '<leader><Tab>', ':e #<CR>', { noremap = true, desc = 'Switch to last buffer' })

-- Formatter
vim.keymap.set('n', '<leader>nf', ':Neoformat<CR>', { noremap = true, desc = 'Run Neoformat' })

-- Quickfix navigation
vim.keymap.set('n', '<leader>cn', ':cnext<CR>', { noremap = true, desc = 'Quickfix next' })
vim.keymap.set('n', '<leader>cp', ':cprevious<CR>', { noremap = true, desc = 'Quickfix previous' })
vim.keymap.set('n', '<leader>cj', ':cnext<CR>', { noremap = true, desc = 'Quickfix next' })
vim.keymap.set('n', '<leader>ck', ':cprevious<CR>', { noremap = true, desc = 'Quickfix previous' })

-- Open Cursor at current position
vim.keymap.set('n', '<leader>ai', function()
  local file = vim.fn.expand('%:p')
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  vim.cmd('!cursor . && cursor --goto ' .. file .. ':' .. line .. ':' .. col)
end, { desc = 'Open Cursor at current position' })
