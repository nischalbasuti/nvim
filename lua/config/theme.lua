-- Light/dark background driven by the desktop theme.
--
-- ~/.local/bin/theme-mode writes the current mode ("dark" | "light") to
-- $XDG_STATE_HOME/theme-mode. This module reads it at startup and watches it,
-- so flipping the desktop theme (Super+Shift+T) reflows running Neovims too.
-- On macOS with no state file it falls back to the system appearance, so the
-- same config behaves sanely over ssh to the Mac.

local M = {}

local COLORSCHEME = 'catppuccin'

local function state_file()
  local dir = vim.env.XDG_STATE_HOME
  if dir == nil or dir == '' then
    dir = vim.fn.expand('~/.local/state')
  end
  return dir .. '/theme-mode'
end

local function detect()
  local path = state_file()
  local fd = io.open(path, 'r')
  if fd then
    local mode = vim.trim(fd:read('l') or '')
    fd:close()
    if mode == 'light' or mode == 'dark' then
      return mode
    end
  end
  if vim.fn.has('mac') == 1 then
    -- AppleInterfaceStyle only exists while dark mode is on.
    local out = vim.fn.system({ 'defaults', 'read', '-g', 'AppleInterfaceStyle' })
    return out:lower():find('dark') and 'dark' or 'light'
  end
  return 'dark'
end

---@param mode string|nil "dark" | "light"; detected when omitted
function M.apply(mode)
  mode = mode or detect()
  -- Track the applied mode ourselves: colors_name ends up flavour-suffixed
  -- (catppuccin-latte / -mocha), so it can't be compared against COLORSCHEME.
  if M._mode == mode and vim.o.background == mode then
    return
  end
  M._mode = mode
  vim.o.background = mode
  -- catppuccin picks its flavour (background.light/dark) at load time, so
  -- re-apply after the switch.
  pcall(vim.cmd.colorscheme, COLORSCHEME)
end

-- fs_event on the file itself: theme-mode truncates in place, so the watch
-- survives a write, but re-arm anyway in case the file is ever replaced. If the
-- file doesn't exist yet (fresh machine, first toggle still to come), watch its
-- directory instead so we catch it being created.
local handle
local function watch()
  local uv = vim.uv or vim.loop
  local path = state_file()
  handle = uv.new_fs_event()
  if not handle then
    return
  end
  local function on_event(err)
    if handle then
      handle:stop()
    end
    if err then
      return
    end
    vim.schedule(function()
      M.apply()
      watch()
    end)
  end
  local ok = handle:start(path, {}, on_event)
  if not ok then
    handle:start(vim.fs.dirname(path), {}, function(err, name)
      if name ~= nil and name ~= vim.fs.basename(path) then
        return -- unrelated file in the same directory
      end
      on_event(err)
    end)
  end
end

function M.setup()
  M.apply()
  watch()

  -- Belt and braces: the file may change while this instance is suspended.
  vim.api.nvim_create_autocmd('FocusGained', {
    group = vim.api.nvim_create_augroup('theme_mode', { clear = true }),
    callback = function()
      M.apply()
    end,
  })

  vim.api.nvim_create_user_command('ThemeMode', function(opts)
    M.apply(opts.args ~= '' and opts.args or nil)
  end, {
    nargs = '?',
    complete = function()
      return { 'dark', 'light' }
    end,
    desc = 'Set background to dark/light (no arg = re-read the desktop theme)',
  })
end

return M
