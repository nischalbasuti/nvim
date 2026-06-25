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

-- Clipboard: every yank to the + register goes to BOTH the local clipboard
-- (pbcopy) and, via OSC 52, whatever terminal is attached -- so over SSH it also
-- lands in the client's clipboard. No SSH detection needed: OSC 52 self-targets
-- the attached terminal, and tmux forwards it because set-clipboard is on.
-- Mirrors the tmux pbcopy + set-clipboard setup. Paste stays on pbpaste (the
-- reliable path); over SSH, paste from the client with the terminal's own paste.
local osc52 = require('vim.ui.clipboard.osc52')
local function copy(reg)
  local emit_osc52 = osc52.copy(reg)
  return function(lines, regtype)
    vim.fn.system({ 'pbcopy' }, table.concat(lines, '\n'))
    emit_osc52(lines, regtype)
  end
end
vim.g.clipboard = {
  name = 'pbcopy+osc52',
  copy = { ['+'] = copy('+'), ['*'] = copy('*') },
  paste = { ['+'] = { 'pbpaste' }, ['*'] = { 'pbpaste' } },
}

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
