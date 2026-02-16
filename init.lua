-- Set leader key BEFORE plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({ import = 'plugins' }, {
  install = { colorscheme = { 'catppuccin' } },
  checker = { enabled = false },
  change_detection = { notify = false },
})

require('config.keymaps')
require('config.autocmds')
