-- git-worktree.lua
-- Neovim module for managing git worktrees

local M = {}

-- Configuration
M.config = {
  default_source_branch = 'origin/staging',
  copy_files = {
    '.env',
    '.env.staging',
    '.env.prod',
    'Caddyfile.prod',
    'Caddyfile.staging',
  },
}

-- Helper: Run git command and return output
local function git_cmd(args, cwd)
  cwd = cwd or vim.fn.getcwd()
  local cmd = vim.list_extend({ 'git', '-C', cwd }, args)
  local result = vim.fn.systemlist(cmd)
  local success = vim.v.shell_error == 0
  return result, success
end

-- Helper: Get git root directory (main worktree)
local function get_git_root()
  local result, success = git_cmd({ 'rev-parse', '--show-toplevel' })
  if success and #result > 0 then
    return result[1]
  end
  return nil
end

-- Helper: Get the main worktree directory (not a linked worktree)
local function get_main_worktree()
  local result, success = git_cmd({ 'worktree', 'list', '--porcelain' })
  if not success or #result == 0 then
    return nil
  end

  for _, line in ipairs(result) do
    if line:match('^worktree ') then
      return line:gsub('^worktree ', '')
    end
  end
  return nil
end

-- Helper: Check if current directory is in a git repo
local function is_git_repo()
  local _, success = git_cmd({ 'rev-parse', '--git-dir' })
  return success
end

-- Helper: Check if branch exists (local or remote)
local function branch_exists(branch_name, cwd)
  local _, local_exists = git_cmd({ 'show-ref', '--verify', '--quiet', 'refs/heads/' .. branch_name }, cwd)
  if local_exists then return true end

  local _, remote_exists = git_cmd({ 'show-ref', '--verify', '--quiet', 'refs/remotes/origin/' .. branch_name }, cwd)
  if remote_exists then return true end

  local _, ref_exists = git_cmd({ 'rev-parse', '--verify', '--quiet', branch_name }, cwd)
  return ref_exists
end

-- Helper: Check if source branch/ref exists
local function source_ref_exists(ref, cwd)
  local _, exists = git_cmd({ 'rev-parse', '--verify', '--quiet', ref }, cwd)
  return exists
end

-- Helper: Get current branch
local function get_current_branch(cwd)
  local result, success = git_cmd({ 'rev-parse', '--abbrev-ref', 'HEAD' }, cwd)
  if success and #result > 0 then
    return result[1]
  end
  return nil
end

-- Helper: Copy file if it exists
local function copy_file(src, dest)
  if vim.fn.filereadable(src) == 1 then
    vim.fn.system({ 'cp', src, dest })
    return vim.v.shell_error == 0
  end
  return false
end

-- Helper: Notify user
local function notify(msg, level)
  level = level or vim.log.levels.INFO
  vim.notify(msg, level, { title = 'Git Worktree' })
end

-- Helper: Set directory for parent shell to cd to
local function set_shell_cd(path)
  local cd_file = os.getenv('HOME') .. '/.nvim_worktree_cd'
  local f = io.open(cd_file, 'w')
  if f then
    f:write(path)
    f:close()
  end
end

-- List all worktrees
function M.list_worktrees()
  if not is_git_repo() then
    notify('Not in a git repository', vim.log.levels.ERROR)
    return {}
  end

  local result, success = git_cmd({ 'worktree', 'list', '--porcelain' })
  if not success then
    notify('Failed to list worktrees', vim.log.levels.ERROR)
    return {}
  end

  local worktrees = {}
  local current = {}

  for _, line in ipairs(result) do
    if line:match('^worktree ') then
      current.path = line:gsub('^worktree ', '')
    elseif line:match('^HEAD ') then
      current.head = line:gsub('^HEAD ', '')
    elseif line:match('^branch ') then
      current.branch = line:gsub('^branch refs/heads/', '')
    elseif line == '' and current.path then
      table.insert(worktrees, current)
      current = {}
    end
  end

  if current.path then
    table.insert(worktrees, current)
  end

  return worktrees
end

-- Create a new worktree
function M.create_worktree(worktree_name, branch_name, source_branch)
  source_branch = source_branch or M.config.default_source_branch

  if not is_git_repo() then
    notify('Not in a git repository', vim.log.levels.ERROR)
    return false
  end

  if not worktree_name or worktree_name == '' then
    notify('Worktree name is required', vim.log.levels.ERROR)
    return false
  end

  if not branch_name or branch_name == '' then
    notify('Branch name is required', vim.log.levels.ERROR)
    return false
  end

  local main_worktree = get_main_worktree()
  if not main_worktree then
    notify('Could not determine main worktree', vim.log.levels.ERROR)
    return false
  end

  local current_dir = vim.fn.getcwd()
  local parent_dir = vim.fn.fnamemodify(current_dir, ':h')
  local worktree_path = parent_dir .. '/' .. worktree_name

  if vim.fn.isdirectory(worktree_path) == 1 then
    notify('Directory already exists: ' .. worktree_path, vim.log.levels.ERROR)
    return false
  end

  local original_branch = get_current_branch(main_worktree)

  if not branch_exists(branch_name, main_worktree) then
    vim.ui.select({ 'Yes', 'No' }, {
      prompt = string.format("Branch '%s' does not exist. Create it from '%s'?", branch_name, source_branch),
    }, function(choice)
      if choice == 'Yes' then
        if not source_ref_exists(source_branch, main_worktree) then
          notify('Source branch does not exist: ' .. source_branch, vim.log.levels.ERROR)
          return
        end

        local _, success = git_cmd({ 'branch', branch_name, source_branch }, main_worktree)
        if not success then
          notify('Failed to create branch: ' .. branch_name, vim.log.levels.ERROR)
          return
        end
        notify("Created branch '" .. branch_name .. "' from '" .. source_branch .. "'")

        M._create_worktree_impl(worktree_path, branch_name, main_worktree, original_branch)
      else
        notify('Worktree creation cancelled', vim.log.levels.WARN)
      end
    end)
  else
    M._create_worktree_impl(worktree_path, branch_name, main_worktree, original_branch)
  end
end

-- Internal: Actually create the worktree and copy files
function M._create_worktree_impl(worktree_path, branch_name, main_worktree, original_branch)
  notify('Creating worktree at ' .. worktree_path .. ' with branch ' .. branch_name)

  local _, success = git_cmd({ 'worktree', 'add', worktree_path, branch_name }, main_worktree)
  if not success then
    notify('Failed to create worktree', vim.log.levels.ERROR)
    return false
  end

  local current = get_current_branch(main_worktree)
  if original_branch and current ~= original_branch then
    git_cmd({ 'checkout', original_branch }, main_worktree)
  end

  local copied_files = {}
  for _, file in ipairs(M.config.copy_files) do
    local src = main_worktree .. '/' .. file
    local dest = worktree_path .. '/' .. file
    if copy_file(src, dest) then
      table.insert(copied_files, file)
    end
  end

  if #copied_files > 0 then
    notify('Copied files: ' .. table.concat(copied_files, ', '))
  end

  notify('Worktree ready at ' .. worktree_path, vim.log.levels.INFO)
  return true
end

-- Remove a worktree
function M.remove_worktree(worktree_path)
  if not is_git_repo() then
    notify('Not in a git repository', vim.log.levels.ERROR)
    return false
  end

  if not worktree_path or worktree_path == '' then
    notify('Worktree path is required', vim.log.levels.ERROR)
    return false
  end

  vim.ui.select({ 'Yes', 'No' }, {
    prompt = 'Remove worktree at ' .. worktree_path .. '?',
  }, function(choice)
    if choice == 'Yes' then
      local _, success = git_cmd({ 'worktree', 'remove', worktree_path, '--force' })
      if success then
        notify('Removed worktree: ' .. worktree_path)
      else
        notify('Failed to remove worktree', vim.log.levels.ERROR)
      end
    end
  end)
end

-- Interactive: Create worktree with prompts
function M.create_worktree_interactive()
  if not is_git_repo() then
    notify('Not in a git repository', vim.log.levels.ERROR)
    return
  end

  vim.ui.input({ prompt = 'Worktree name: ' }, function(worktree_name)
    if not worktree_name or worktree_name == '' then
      return
    end

    vim.ui.input({ prompt = 'Branch name: ', default = worktree_name }, function(branch_name)
      if not branch_name or branch_name == '' then
        return
      end

      vim.ui.input({
        prompt = 'Source branch (leave empty for default): ',
        default = M.config.default_source_branch,
      }, function(source_branch)
        if not source_branch or source_branch == '' then
          source_branch = M.config.default_source_branch
        end

        M.create_worktree(worktree_name, branch_name, source_branch)
      end)
    end)
  end)
end

-- Interactive: Select and remove worktree
function M.remove_worktree_interactive()
  local worktrees = M.list_worktrees()
  local main_worktree = get_main_worktree()

  if #worktrees <= 1 then
    notify('No worktrees to remove (only main worktree exists)', vim.log.levels.WARN)
    return
  end

  local removable = {}
  for _, wt in ipairs(worktrees) do
    if wt.path ~= main_worktree then
      table.insert(removable, wt)
    end
  end

  if #removable == 0 then
    notify('No worktrees to remove', vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, wt in ipairs(removable) do
    table.insert(items, string.format('%s (%s)', wt.path, wt.branch or 'detached'))
  end

  vim.ui.select(items, { prompt = 'Select worktree to remove:' }, function(_, idx)
    if idx then
      M.remove_worktree(removable[idx].path)
    end
  end)
end

-- Interactive: Switch to worktree
function M.switch_to_worktree()
  local worktrees = M.list_worktrees()

  if #worktrees == 0 then
    notify('No worktrees found', vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, wt in ipairs(worktrees) do
    table.insert(items, string.format('%s (%s)', wt.path, wt.branch or 'detached'))
  end

  vim.ui.select(items, { prompt = 'Select worktree to open:' }, function(_, idx)
    if idx then
      local path = worktrees[idx].path
      vim.cmd('cd ' .. vim.fn.fnameescape(path))
      set_shell_cd(path)
      notify('Switched to: ' .. path)
    end
  end)
end

-- Show worktrees in a floating window
function M.show_worktrees()
  local worktrees = M.list_worktrees()
  local main_worktree = get_main_worktree()

  if #worktrees == 0 then
    notify('No worktrees found', vim.log.levels.WARN)
    return
  end

  local lines = { 'Git Worktrees:', '' }
  for i, wt in ipairs(worktrees) do
    local branch = wt.branch or 'detached'
    local marker = wt.path == main_worktree and ' (main)' or ''
    table.insert(lines, string.format('%d. %s [%s]%s', i, wt.path, branch, marker))
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  local width = math.min(100, vim.o.columns - 4)
  local height = #lines + 2
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Worktrees ',
    title_pos = 'center',
  })

  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })
  vim.keymap.set('n', '<Esc>', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })
end

-- Setup function
function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend('force', M.config, opts)

  vim.api.nvim_create_user_command('WorktreeCreate', function(cmd_opts)
    local args = vim.split(cmd_opts.args, ' ')
    if #args >= 2 then
      M.create_worktree(args[1], args[2], args[3])
    elseif #args == 1 and args[1] ~= '' then
      M.create_worktree(args[1], args[1])
    else
      M.create_worktree_interactive()
    end
  end, {
    nargs = '*',
    desc = 'Create a new git worktree',
  })

  vim.api.nvim_create_user_command('WorktreeRemove', function(cmd_opts)
    if cmd_opts.args ~= '' then
      M.remove_worktree(cmd_opts.args)
    else
      M.remove_worktree_interactive()
    end
  end, {
    nargs = '?',
    desc = 'Remove a git worktree',
  })

  vim.api.nvim_create_user_command('WorktreeList', function()
    M.show_worktrees()
  end, {
    desc = 'List all git worktrees',
  })

  vim.api.nvim_create_user_command('WorktreeSwitch', function()
    M.switch_to_worktree()
  end, {
    desc = 'Switch to a git worktree',
  })
end

return M
