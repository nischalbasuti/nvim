-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use 'ddrscott/vim-side-search'

  use({
  "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup()
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
})

  use 'jiangmiao/auto-pairs'
  use 'tpope/vim-surround'

  use 'sunjon/Shade.nvim'

  use {
    "SmiteshP/nvim-navbuddy",
    requires = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim"
    }
  }

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      "mfussenegger/nvim-dap",
      "jayp0521/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",

      -- Useful status updates for LSP
      {'j-hui/fidget.nvim', tag = "legacy"},

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip'
    },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use 'nvim-treesitter/nvim-treesitter-context'

  use 'RRethy/vim-illuminate'

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'
  use 'APZelos/blamer.nvim'

  use {'akinsho/git-conflict.nvim', tag = "*", config = function()
    require('git-conflict').setup()
  end}

  use 'navarasu/onedark.nvim' -- Theme inspired by Atom
  use { "catppuccin/nvim", as = "catppuccin" }
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }
  use { "nvim-telescope/telescope-file-browser.nvim" }
  use 'nvim-tree/nvim-web-devicons'
  use 'nvim-tree/nvim-tree.lua'

  use {'nvim-telescope/telescope-ui-select.nvim' }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- nvim-tree stuff
--
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local HEIGHT_RATIO = 0.8  -- You can change this
local WIDTH_RATIO = 0.5   -- You can change this too


local function my_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
    vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
    vim.keymap.set('n', 'n',     api.fs.create,                  opts('New File'))
    -- vim.keymap.set('n', 'u', api.fs.dir_up,        opts('Move Dir Up'))
    vim.keymap.set( "n", "<Esc>", ":NvimTreeClose<CR>", opts('Close'))
end

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    on_attach = my_on_attach,
    view = {
        float = {
            enable = true,
            open_win_config = function()
                local screen_w = vim.opt.columns:get()
                local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                local window_w = screen_w * WIDTH_RATIO
                local window_h = screen_h * HEIGHT_RATIO
                local window_w_int = math.floor(window_w)
                local window_h_int = math.floor(window_h)
                local center_x = (screen_w - window_w) / 2
                local center_y = ((vim.opt.lines:get() - window_h) / 2)

                - vim.opt.cmdheight:get()

                return {
                    border = 'rounded',
                    relative = 'editor',
                    row = center_y,
                    col = center_x,
                    width = window_w_int,
                    height = window_h_int,

                }
            end,
        },
        width = function()
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})

vim.api.nvim_set_keymap("n", "<leader>dc", "<CMD>lua require('dap').continue()<CR>", { noremap = true, silent = true })

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- nischal
vim.o.expandtab = true
vim.o.smartindent = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.o.scrolloff = 4

vim.api.nvim_create_autocmd("FileType", {
    pattern = "javascript",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end
})
-- /nischal

-- [[ Setting options ]]
-- See `:help vim.o`

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
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'catppuccin',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
vim.opt.list = true
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "space:⋅"

vim.opt.termguicolors = true
-- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]


require('indent_blankline').setup {
  -- char = '┊',
  show_trailing_blankline_indent = false,
  show_end_of_line = true,
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
  -- char_highlight_list = {
  --   "IndentBlanklineIndent1",
  --   "IndentBlanklineIndent2",
  --   "IndentBlanklineIndent3",
  --   "IndentBlanklineIndent4",
  --   "IndentBlanklineIndent5",
  --   "IndentBlanklineIndent6",
  -- },
}

-- Git blamer
vim.g.blamer_enabled = 1
vim.g.blamer_delay = 500
vim.g.blamer_date_format = '20%y/%m/%d %H:%M'
vim.g.blamer_relative_time = 1
vim.g.blamer_show_in_visual_modes = 0
vim.g.blamer_prefix = ' > '

-- vim.cmd [[highlight Blamer guifg=lightgrey]]

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    path_display={"truncate"},
    file_ignore_patterns = { "node_modules", ".git" },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
      n = {
        ['<C-d>'] = 'delete_buffer',
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require("telescope").load_extension, "file_browser")

pcall(require("telescope").load_extension("ui-select"))

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').oldfiles, { desc = '[S]earch [R]ecently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>tr', require('telescope.builtin').resume, { desc = '[T]elescope [R]esume' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sp', require('telescope.builtin').git_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set( "n", "<leader>tb", ":Telescope file_browser<CR>", { noremap = true, desc='[F]ile [B]rowser' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'vim' },
  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)


-- LSP settings.
--
local navic = require("nvim-navic")
local navbuddy = require("nvim-navbuddy")

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
    -- print("lsconfig on_attach", client, bufnr)

    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
        navbuddy.attach(client, bufnr)
    end

  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', function() vim.lsp.buf.code_action() end, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap('<leader>i', vim.lsp.buf.hover, '[I]nspect')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  -- sumneko_lua = {
  --   Lua = {
  --     workspace = { checkThirdParty = false },
  --     telemetry = { enable = false },
  --   },
  -- },
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup({
  PATH = "prepend",
})

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp', priority = 8 },
    { name = 'luasnip' },
    { name = 'path', priority = 2 },
    { name = 'buffer', priority = 1, keyword_length = 4 },
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  }
}

require('dap.breakpoints')
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
--
--
--

local present_dapui, dapui = pcall(require, "dapui")
local present_dap, dap = pcall(require, "dap")
local present_virtual_text, dap_vt = pcall(require, "nvim-dap-virtual-text")
local _, shade = pcall(require, "shade")

if not present_dapui or not present_dap or not present_virtual_text then
  return
end

-- ╭───────────────────────────────────────────────────────╮
-- │ DAP Virtual Text Setup                                   │
-- ╰───────────────────────────────────────────────────────╯
dap_vt.setup({
  enabled = true, -- enable this plugin (the default)
  enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
  highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
  show_stop_reason = true, -- show stop reason when stopped for exceptions
  commented = false, -- prefix virtual text with comment string
  only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
  all_references = false, -- show virtual text on all all references of the variable (not only definitions)
  filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)

  -- Experimental Features:
  virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
  all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
  virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
  virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
})

-- ╭──────────────────────────────────────────────────────╮
-- │ DAP UI Setup                                             │
-- ╰──────────────────────────────────────────────────────╯
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7"),
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "rounded", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
  }
})
-- ╭──────────────────────────────────────────────────────╮
-- │ DAP Setup                                                │
-- ╰──────────────────────────────────────────────────────╯
dap.set_log_level('TRACE');

-- Automatically open UI
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open();
  -- shade.toggle();
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close();
  -- shade.toggle();
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close();
  -- shade.toggle();
end

-- Enable virtual text
vim.g.dap_virtual_text = true

-- ╭──────────────────────────────────────────────────────╮
-- │ Icons                                                    │
-- ╰──────────────────────────────────────────────────────╯
vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '⭐️', texthl = '', linehl = '', numhl = '' })

-- ╭──────────────────────────────────────────────────────╮
-- │ Keybindings                                              │
-- ╰──────────────────────────────────────────────────────╯
vim.keymap.set('n', '<leader>db', require('dap').toggle_breakpoint, { desc = 'Add [D]ebugger [B]reakpoint' })
-- vim.api.nvim_set_keymap("n", "<leader>db", "<CMD>lua require('dap').toggle_breakpoint()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dc", "<CMD>lua require('dap').continue()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dd", "<CMD>lua require('dap').continue()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dh", "<CMD>lua require('dapui').eval()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>di", "<CMD>lua require('dap').step_into()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>do", "<CMD>lua require('dap').step_out()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dO", "<CMD>lua require('dap').step_over()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dt", "<CMD>lua require('dap').terminate()<CR>", { noremap = true, silent = true })

-- ╭──────────────────────────────────────────────────────╮
-- │ Adapters                                                 │
-- ╰──────────────────────────────────────────────────────╯
-- NODE / TYPESCRIPT
dap.adapters.node2 = {
  type = 'executable';
  command = 'node',
  args = { vim.fn.stdpath "data" .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' };
}

-- Chrome
-- dap.adapters.chrome = {
--   type = 'executable',
--   command = 'node',
--   args = { vim.fn.stdpath "data" .. '/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js' };
-- }

-- dap.adapters.chrome = {
--   type = 'executable',
--   command = 'node',
--   args = { vim.fn.stdpath "data" .. '/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js --remote-debugging-port=9222' };
-- }

dap.adapters.firefox = {
    type = 'executable',
    command = 'bash',
    args ={ '/home/nischal/.local/share/nvim/mason/packages/firefox-debug-adapter/firefox-debug-adapter'};
}
--

-- require ('mason-nvim-dap').setup({
--     ensure_installed = {'firefox',},
--     handlers = {}, -- sets up dap in the predefined manner
-- })
dap.configurations.javascript = {
  {
    type = 'firefox',
    request = 'attach',
    name = 'Attach to Firefox',
    host = 'localhost',
    port = 9222,
    url = 'http://localhost:8000',
  },
}

dap.adapters.lldb = {
  type = 'executable',
  command =  vim.fn.stdpath "data" .. '/mason/packages/codelldb/extension/lldb/bin/lldb' ,
  args = {}

  -- command = 'lldb',
  -- args = { vim.fn.stdpath "data" .. '/mason/packages/codelldb/extension/lldb/bin/lldb' };
  -- /home/nischal/.local/share/nvim/mason/packages/codelldb/extension/lldb/bin/lldb
}
dap.configurations.rust = {
    {
        name= "Debug Rust",
        type = "lldb",
        request = "launch",
        program = "${workspaceFolder}/target/debug/${workspaceRootFolderName}",
        -- args= [],
        cwd= "${workspaceFolder}"
    }
}

-- ╭──────────────────────────────────────────────────────╮
-- │ Configurations                                           │
-- ╰───────────────────────────────────────────────────────╯
dap.configurations.typescript = {
    {
        type = "node2",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
    },
    {
        type = "node2",
        request = "attach",
        name = "Attach",
        processId = require'dap.utils'.pick_process,
        cwd = "${workspaceFolder}",
    }
}
-- dap.configurations.javascript = {
--   {
--     type = 'node2';
--     request = 'launch';
--     program = '${file}';
--     cwd = vim.fn.getcwd();
--     sourceMaps = true;
--     protocol = 'inspector';
--     console = 'integratedTerminal';
--   }
-- }

-- dap.configurations.javascript = {
--   {
--     type = 'chrome',
--     request = 'attach',
--     program = '${file}',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = 'inspector',
--     port = 9222,
--     webRoot = '${workspaceFolder}'
--   }
-- }

-- dap.configurations.javascriptreact = {
--   {
--     type = 'chrome',
--     request = 'attach',
--     program = '${file}',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = 'inspector',
--     port = 9222,
--     webRoot = '${workspaceFolder}'
--   }
-- }
--
-- dap.configurations.typescriptreact = {
--   {
--     type = 'chrome',
--     request = 'attach',
--     program = '${file}',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = 'inspector',
--     port = 9222,
--     webRoot = '${workspaceFolder}'
--   }
-- }
--
vim.cmd[[
noremap <leader>y "+y
noremap <Leader>p "+p
noremap <Leader>d "+d
]]

-- vim.keymap.set( "n", "<leader>y", '"+y', { noremap = true, desc='Yank to clipboard' })
vim.cmd [[
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
]]

vim.keymap.set( "n", "<leader>b", ":NvimTreeFindFileToggle<CR>", { noremap = true, desc='[F]ile [B]rowser' })

vim.cmd [[set expandtab]]




local navbuddy = require("nvim-navbuddy")
local actions = require("nvim-navbuddy.actions")

navbuddy.setup {
    window = {
        border = "single",  -- "rounded", "double", "solid", "none"
                            -- or an array with eight chars building up the border in a clockwise fashion
                            -- starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
        size = "60%",       -- Or table format example: { height = "40%", width = "100%"}
        position = "50%",   -- Or table format example: { row = "100%", col = "0%"}
        scrolloff = nil,    -- scrolloff value within navbuddy window
        sections = {
            left = {
                size = "20%",
                border = nil, -- You can set border style for each section individually as well.
            },
            mid = {
                size = "40%",
                border = nil,
            },
            right = {
                -- No size option for right most section. It fills to
                -- remaining area.
                border = nil,
                preview = "leaf",  -- Right section can show previews too.
                                   -- Options: "leaf", "always" or "never"
            }
        },
    },
    node_markers = {
        enabled = true,
        icons = {
            leaf = "  ",
            leaf_selected = " → ",
            branch = " ",
        },
    },
    icons = {
        File          = "󰈙 ",
        Module        = " ",
        Namespace     = "󰌗 ",
        Package       = " ",
        Class         = "󰌗 ",
        Method        = "󰆧 ",
        Property      = " ",
        Field         = " ",
        Constructor   = " ",
        Enum          = "󰕘",
        Interface     = "󰕘",
        Function      = "󰊕 ",
        Variable      = "󰆧 ",
        Constant      = "󰏿 ",
        String        = " ",
        Number        = "󰎠 ",
        Boolean       = "◩ ",
        Array         = "󰅪 ",
        Object        = "󰅩 ",
        Key           = "󰌋 ",
        Null          = "󰟢 ",
        EnumMember    = " ",
        Struct        = "󰌗 ",
        Event         = " ",
        Operator      = "󰆕 ",
        TypeParameter = "󰊄 ",
    },
    use_default_mappings = true,            -- If set to false, only mappings set
                                            -- by user are set. Else default
                                            -- mappings are used for keys
                                            -- that are not set by user
    mappings = {
        ["<esc>"] = actions.close(),        -- Close and cursor to original location
        ["q"] = actions.close(),

        ["j"] = actions.next_sibling(),     -- down
        ["k"] = actions.previous_sibling(), -- up

        ["h"] = actions.parent(),           -- Move to left panel
        ["l"] = actions.children(),         -- Move to right panel
        ["0"] = actions.root(),             -- Move to first panel

        ["v"] = actions.visual_name(),      -- Visual selection of name
        ["V"] = actions.visual_scope(),     -- Visual selection of scope

        ["y"] = actions.yank_name(),        -- Yank the name to system clipboard "+
        ["Y"] = actions.yank_scope(),       -- Yank the scope to system clipboard "+

        ["i"] = actions.insert_name(),      -- Insert at start of name
        ["I"] = actions.insert_scope(),     -- Insert at start of scope

        ["a"] = actions.append_name(),      -- Insert at end of name
        ["A"] = actions.append_scope(),     -- Insert at end of scope

        ["r"] = actions.rename(),           -- Rename currently focused symbol

        ["d"] = actions.delete(),           -- Delete scope

        ["f"] = actions.fold_create(),      -- Create fold of current scope
        ["F"] = actions.fold_delete(),      -- Delete fold of current scope

        ["c"] = actions.comment(),          -- Comment out current scope

        ["<enter>"] = actions.select(),     -- Goto selected symbol
        ["o"] = actions.select(),

        ["J"] = actions.move_down(),        -- Move focused node down
        ["K"] = actions.move_up(),          -- Move focused node up

        ["t"] = actions.telescope({         -- Fuzzy finder at current level.
            layout_config = {               -- All options that can be
                height = 0.60,              -- passed to telescope.nvim's
                width = 0.60,               -- default can be passed here.
                prompt_position = "top",
                preview_width = 0.50
            },
            layout_strategy = "horizontal"
        }),

        ["g?"] = actions.help(),            -- Open mappings help window
    },
    lsp = {
        auto_attach = false,   -- If set to true, you don't need to manually use attach function
        preference = nil,      -- list of lsp server names in order of preference
    },
    source_buffer = {
        follow_node = true,    -- Keep the current node in focus on the source buffer
        highlight = true,      -- Highlight the currently focused node
        reorient = "smart",    -- "smart", "top", "mid" or "none"
        scrolloff = nil        -- scrolloff value when navbuddy is open
    }
}

vim.keymap.set( "n", "<leader>nb", ":Navbuddy<CR>", { noremap = true, desc='[N]av[B]uddy' })
vim.keymap.set('n', '<leader>gr', function () require('telescope.builtin').lsp_references{ path_display = { "truncate" } } end, { desc = '[G]oto [R]eferences' })


-- switch to last buffer
vim.keymap.set( "n",
    "<leader><Tab>",
    ":e #<CR>",
    { noremap = true, desc='Switch to last buffer' })


-- Automatically source .zshrc on save
vim.cmd([[
  autocmd BufWritePost ~/.zshrc !source ~/.zshrc > /dev/null
]])

vim.cmd([[
  set colorcolumn=81,121
]])

require("chatgpt").setup({
    api_key = "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"
})


