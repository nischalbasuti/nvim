-- Keymaps (from after/plugin/keymap.lua, modernized)

-- Don't do anything when you hit space in normal/visual mode
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Split navigation
vim.keymap.set('n', '<leader>h', '<C-w><C-h>', { noremap = true, desc = 'Move to left split' })
vim.keymap.set('n', '<leader>l', '<C-w><C-l>', { noremap = true, desc = 'Move to right split' })
vim.keymap.set('n', '<leader>j', '<C-w><C-j>', { noremap = true, desc = 'Move to below split' })
vim.keymap.set('n', '<leader>k', '<C-w><C-k>', { noremap = true, desc = 'Move to above split' })

-- Scroll the viewport a few lines at a time
vim.keymap.set({ 'n', 'x' }, '<C-j>', '3<C-e>', { noremap = true, desc = 'Scroll down 3 lines' })
vim.keymap.set({ 'n', 'x' }, '<C-k>', '3<C-y>', { noremap = true, desc = 'Scroll up 3 lines' })

-- Copy current file path to system clipboard
vim.keymap.set('n', '<leader>yf', function()
  vim.fn.setreg('+', vim.fn.expand('%'))
end, { desc = 'Copy file path to clipboard' })

local function file_ref(include_normal_line)
  local file = vim.fn.expand('%')
  local mode = vim.fn.mode()

  if mode == 'v' or mode == 'V' or mode == '\22' then
    local start_line, end_line = vim.fn.line('v'), vim.fn.line('.')
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    local ref = start_line == end_line and string.format('%s#L%d', file, start_line)
      or string.format('%s#L%d-L%d', file, start_line, end_line)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
    return ref
  end

  if include_normal_line then
    return string.format('%s#L%d', file, vim.fn.line('.'))
  end

  return file
end

-- Copy file#Lline reference to system clipboard (harness-neutral file+line pointer)
vim.keymap.set({ 'n', 'v' }, '<leader>yl', function()
  vim.fn.setreg('+', file_ref(true))
end, { desc = 'Copy file:line reference to clipboard' })

local function adjacent_tmux_pane()
  for _, direction in ipairs({ '{right-of}', '{left-of}', '{down-of}', '{up-of}' }) do
    local pane = vim.fn.system({ 'tmux', 'display-message', '-p', '-t', direction, '#{pane_id}' })
    if vim.v.shell_error == 0 then
      pane = vim.trim(pane)
      if pane ~= '' then
        return pane
      end
    end
  end
end

-- Send the file path or selected line range to an adjacent tmux pane without submitting it
vim.keymap.set({ 'n', 'v' }, '<leader>tl', function()
  if not vim.env.TMUX then
    vim.notify('Not running inside tmux', vim.log.levels.WARN)
    return
  end

  local target = adjacent_tmux_pane()
  if not target then
    vim.notify('No adjacent tmux pane found', vim.log.levels.WARN)
    return
  end

  vim.fn.system({ 'tmux', 'send-keys', '-t', target, '-l', file_ref(false) })
  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to send reference to tmux pane', vim.log.levels.ERROR)
  end
end, { desc = 'Send file reference to tmux pane' })

-- System clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { noremap = true, desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>yy', '"+y', { noremap = true, desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { noremap = true, desc = 'Paste from clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"+d', { noremap = true, desc = 'Delete to clipboard' })

-- Paste last yank (not last delete)
vim.keymap.set({ 'n', 'v' }, '<leader>0', '"0p', { noremap = true, desc = 'Paste last yank' })

-- Switch to last buffer
vim.keymap.set('n', '<leader><Tab>', ':e #<CR>', { noremap = true, desc = 'Switch to last buffer' })

-- Insert the current local date and time at the cursor
vim.keymap.set('n', '<leader>id', function()
  vim.api.nvim_put({ os.date('%Y-%m-%d %H:%M:%S') }, 'c', true, true)
end, { desc = 'Insert current date and time' })

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

vim.keymap.set('n', '<leader>dvo', function()
  local builtin = require('telescope.builtin')
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  builtin.git_branches({
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        vim.cmd('DiffviewOpen ' .. selection.value .. '...HEAD')
      end)

      return true
    end,
  })
end, { desc = 'Diff branch against HEAD' })

local function select_git_commit(prompt_title, on_select)
  local builtin = require('telescope.builtin')
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  builtin.git_commits({
    prompt_title = prompt_title,
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection then
          vim.schedule(function()
            on_select(selection.value)
          end)
        end
      end)

      return true
    end,
  })
end

vim.keymap.set('n', '<leader>dvc', function()
  select_git_commit('Commit', function(commit)
    vim.cmd('DiffviewOpen ' .. commit .. '^!')
  end)
end, { desc = 'Diff changes in commit' })

vim.keymap.set('n', '<leader>dvr', function()
  select_git_commit('Older commit', function(older_commit)
    select_git_commit('Newer commit', function(newer_commit)
      vim.cmd('DiffviewOpen ' .. older_commit .. '..' .. newer_commit)
    end)
  end)
end, { desc = 'Diff range between commits' })

-- Compare gitsigns against a chosen commit in normal buffers (LSP etc. keep working)
vim.keymap.set('n', '<leader>dvsc', function()
  select_git_commit('Gitsigns base', function(commit)
    require('gitsigns').change_base(commit, true)
    vim.notify('gitsigns base: ' .. commit)
  end)
end, { desc = 'Gitsigns: diff against commit' })

vim.keymap.set('n', '<leader>dvsb', function()
  local builtin = require('telescope.builtin')
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  builtin.git_branches({
    prompt_title = 'Gitsigns base',
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          require('gitsigns').change_base(selection.value, true)
          vim.notify('gitsigns base: ' .. selection.value)
        end
      end)
      return true
    end,
  })
end, { desc = 'Gitsigns: diff against branch' })

vim.keymap.set('n', '<leader>dvsr', function()
  require('gitsigns').reset_base(true)
  vim.notify('gitsigns base: index')
end, { desc = 'Gitsigns: reset base to index' })

vim.keymap.set('n', '<leader>dvsq', function()
  require('gitsigns').setqflist('all')
end, { desc = 'Gitsigns: all hunks vs base to quickfix' })

vim.keymap.set('n', '<leader>dvst', function()
  require('gitsigns').setqflist('all', { open = false }, function(err)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end
    require('telescope.builtin').quickfix({ prompt_title = 'Gitsigns hunks' })
  end)
end, { desc = 'Gitsigns: all hunks vs base in Telescope' })

vim.keymap.set('n', '<leader>dvf', function()
  local base = require('gitsigns.config').config.base
  local toplevel = vim.trim(vim.fn.system({ 'git', 'rev-parse', '--show-toplevel' }))
  if vim.v.shell_error ~= 0 then
    vim.notify('Not in a git repo', vim.log.levels.WARN)
    return
  end
  local cmd = { 'git', 'diff', '--name-only', '--relative' }
  if base then
    table.insert(cmd, base)
  end
  require('telescope.builtin').find_files({
    prompt_title = 'Changed files vs ' .. (base or 'index'),
    cwd = toplevel,
    find_command = cmd,
  })
end, { desc = 'Gitsigns: changed files vs base in Telescope' })
