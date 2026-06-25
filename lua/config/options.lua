-- Options (merged from lua/nischal/set.lua + after/plugin/misc-setting.lua)

-- Disable netrw (must run before plugins)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Neoformat
vim.g.neoformat_try_node_exe = 1

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Navigation
vim.opt.scrolloff = 4
vim.opt.mouse = 'a'

-- Clipboard: over SSH, route the + register through OSC 52 so yanks reach the
-- SSH client's clipboard rather than the server's. Locally, leave Nvim's
-- default (pbcopy) provider untouched. Mirrors the tmux set-clipboard setup.
-- SSH_CONNECTION (not SSH_TTY) is the one tmux refreshes via update-environment,
-- so it's the reliable signal for nvim launched inside a tmux pane.
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  local osc52 = require('vim.ui.clipboard.osc52')
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*') },
    paste = { ['+'] = osc52.paste('+'), ['*'] = osc52.paste('*') },
  }
end

-- Search
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Files / History
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true
vim.opt.hidden = true

-- UI
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '81,121'
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars:append('eol:↴')

-- Performance
vim.opt.updatetime = 250

-- Completion
vim.opt.completeopt = 'menuone,noselect'

-- Terminal italics (no pure Lua equivalent)
vim.cmd [[
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
]]
