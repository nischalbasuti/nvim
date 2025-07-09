-- Avante configuration with Copilot as provider
require('avante').setup({
  -- Set Copilot as the default provider
  provider = 'copilot',
  
  -- Provider configurations
  providers = {
    copilot = {
      -- Copilot configuration
      -- Note: Copilot provider uses the copilot.lua plugin
      -- Make sure you have zbirenbaum/copilot.lua installed and configured
    },
  },
  
  -- Behavior settings
  behaviour = {
    auto_suggestions = false, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
    minimize_diff = true,
    enable_token_counting = true,
    auto_approve_tool_permissions = false,
  },
  
  -- Window configuration
  windows = {
    position = "right", -- the position of the sidebar
    wrap = true,
    width = 30, -- default % based on available width
    sidebar_header = {
      enabled = true,
      align = "center",
      rounded = true,
    },
    input = {
      prefix = "> ",
      height = 8,
    },
    edit = {
      border = "rounded",
      start_insert = true,
    },
    ask = {
      floating = false,
      start_insert = true,
      border = "rounded",
      focus_on_apply = "ours",
    },
  },
  
  -- Mappings (these will be auto-set by Avante)
  mappings = {
    diff = {
      ours = "co",
      theirs = "ct",
      all_theirs = "ca",
      both = "cb",
      cursor = "cc",
      next = "]x",
      prev = "[x",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    jump = {
      next = "]]",
      prev = "[[",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
    cancel = {
      normal = { "<C-c>", "<Esc>", "q" },
      insert = { "<C-c>" },
    },
    sidebar = {
      apply_all = "A",
      apply_cursor = "a",
      retry_user_request = "r",
      edit_user_request = "e",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
      remove_file = "d",
      add_file = "@",
      close = { "<Esc>", "q" },
    },
  },
  
  -- Hints
  hints = { enabled = true },
  
  -- Diff configuration
  diff = {
    autojump = true,
    list_opener = "copen",
    override_timeoutlen = 500,
  },
  
  -- Suggestion configuration
  suggestion = {
    debounce = 600,
    throttle = 600,
  },
  
  -- Highlights
  highlights = {
    diff = {
      current = "DiffText",
      incoming = "DiffAdd",
    },
  },
})

-- Set up additional key mappings for Avante
local function setup_keymaps()
  -- Note: Avante auto-sets most keymaps, but we can add custom ones
  
  -- Quick access to Avante ask
  vim.keymap.set('n', '<leader>aa', function()
    vim.cmd('AvanteAsk')
  end, { desc = 'Avante: Ask' })
  
  -- Quick access to Avante chat
  vim.keymap.set('n', '<leader>ac', function()
    vim.cmd('AvanteChat')
  end, { desc = 'Avante: Chat' })
  
  -- Toggle Avante sidebar
  vim.keymap.set('n', '<leader>at', function()
    vim.cmd('AvanteToggle')
  end, { desc = 'Avante: Toggle Sidebar' })
  
  -- Focus Avante sidebar
  vim.keymap.set('n', '<leader>af', function()
    vim.cmd('AvanteFocus')
  end, { desc = 'Avante: Focus Sidebar' })
  
  -- Stop current AI request
  vim.keymap.set('n', '<leader>as', function()
    vim.cmd('AvanteStop')
  end, { desc = 'Avante: Stop Request' })
  
  -- Switch provider
  vim.keymap.set('n', '<leader>ap', function()
    vim.cmd('AvanteSwitchProvider')
  end, { desc = 'Avante: Switch Provider' })
  
  -- Show models
  vim.keymap.set('n', '<leader>am', function()
    vim.cmd('AvanteModels')
  end, { desc = 'Avante: Show Models' })
  
  -- Show repo map
  vim.keymap.set('n', '<leader>ar', function()
    vim.cmd('AvanteShowRepoMap')
  end, { desc = 'Avante: Show Repo Map' })
end

-- Initialize key mappings
setup_keymaps()

-- Print setup confirmation
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.schedule(function()
      print('Avante configured with Copilot as provider')
      print('Use <leader>aa to ask Avante')
      print('Use <leader>ac to start chat')
      print('Use <leader>at to toggle sidebar')
      print('Use <leader>af to focus sidebar')
      print('Use <leader>as to stop current request')
      print('Use <leader>ap to switch provider')
      print('Use <leader>am to show models')
      print('Use <leader>ar to show repo map')
      print('')
      print('Default Avante keymaps:')
      print('  <leader>aa - Show sidebar')
      print('  <leader>at - Toggle sidebar visibility')
      print('  <leader>ar - Refresh sidebar')
      print('  <leader>af - Switch sidebar focus')
    end)
  end,
  once = true,
}) 