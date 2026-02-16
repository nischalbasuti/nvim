-- Autocommands (from after/plugin/autocmds.lua + misc-setting.lua)

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- JS/TS: 2-space indent
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript' },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- Go: use tabs
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

-- Quickfix: disable wrapping
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.opt_local.wrap = false
  end,
})

-- Load git-worktree module
require('custom.git-worktree').setup()
