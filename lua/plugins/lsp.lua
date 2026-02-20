return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      {
        'hasansujon786/nvim-navbuddy',
        dependencies = {
          'SmiteshP/nvim-navic',
          'MunifTanjim/nui.nvim',
        },
        config = function()
          local actions = require('nvim-navbuddy.actions')
          require('nvim-navbuddy').setup({
            window = {
              border = 'single',
              size = '60%',
              position = '50%',
              scrolloff = nil,
              sections = {
                left = { size = '20%', border = nil },
                mid = { size = '40%', border = nil },
                right = { border = nil, preview = 'leaf' },
              },
            },
            node_markers = {
              enabled = true,
              icons = {
                leaf = '  ',
                leaf_selected = ' → ',
                branch = ' ',
              },
            },
            use_default_mappings = true,
            mappings = {
              ['<esc>'] = actions.close(),
              ['q'] = actions.close(),
              ['j'] = actions.next_sibling(),
              ['k'] = actions.previous_sibling(),
              ['h'] = actions.parent(),
              ['l'] = actions.children(),
              ['0'] = actions.root(),
              ['v'] = actions.visual_name(),
              ['V'] = actions.visual_scope(),
              ['y'] = actions.yank_name(),
              ['Y'] = actions.yank_scope(),
              ['i'] = actions.insert_name(),
              ['I'] = actions.insert_scope(),
              ['a'] = actions.append_name(),
              ['A'] = actions.append_scope(),
              ['r'] = actions.rename(),
              ['d'] = actions.delete(),
              ['f'] = actions.fold_create(),
              ['F'] = actions.fold_delete(),
              ['c'] = actions.comment(),
              ['<enter>'] = actions.select(),
              ['o'] = actions.select(),
              ['J'] = actions.move_down(),
              ['K'] = actions.move_up(),
              ['t'] = actions.telescope({
                layout_config = {
                  height = 0.60,
                  width = 0.60,
                  prompt_position = 'top',
                  preview_width = 0.50,
                },
                layout_strategy = 'horizontal',
              }),
              ['g?'] = actions.help(),
            },
            lsp = { auto_attach = true, preference = nil },
            source_buffer = {
              follow_node = true,
              highlight = true,
              reorient = 'smart',
              scrolloff = nil,
            },
          })
        end,
      },
      {
        'antosha417/nvim-lsp-file-operations',
        dependencies = {
          'nvim-lua/plenary.nvim',
          'nvim-tree/nvim-tree.lua',
        },
      },
    },
    config = function()
      local navic = require('nvim-navic')
      local navbuddy = require('nvim-navbuddy')

      -- Default border for all LSP floating windows
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })

      vim.diagnostic.config({
        float = { border = 'single' },
      })

      local servers = {
        clangd = {},
      }

      -- LSP keymaps and attach handlers
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local bufnr = ev.buf

          if client and client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
            navbuddy.attach(client, bufnr)
          end

          local nmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. (desc or '') })
          end

          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
          nmap('<leader>gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation (Telescope)')
          nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

          nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
          nmap('<leader>gr', function()
            require('telescope.builtin').lsp_references({ path_display = { 'truncate' } })
          end, '[G]oto [R]eferences (Telescope)')

          nmap('<leader>K', vim.lsp.buf.signature_help, 'Signature Help')

          nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
          nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
          nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[W]orkspace [L]ist Folders')

          nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        end,
      })

      -- Mason
      require('mason').setup({ PATH = 'prepend' })

      local mason_lspconfig = require('mason-lspconfig')
      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })

      -- Configure LSP servers (Neovim 0.11+ native API)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      for server_name, server_config in pairs(servers) do
        vim.lsp.config[server_name] = {
          capabilities = capabilities,
          settings = server_config,
        }
        vim.lsp.enable(server_name)
      end

      -- LSP file operations
      require('lsp-file-operations').setup()

      vim.cmd([[highlight FloatBorder guifg=white guibg=#000000]])

      -- Diagnostic keymaps
      vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { desc = 'Go to previous diagnostic' })
      vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { desc = 'Go to next diagnostic' })
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Set diagnostic loclist' })

      -- Custom hover
      vim.keymap.set('n', 'K', function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local position_encoding = clients[1] and clients[1].offset_encoding or 'utf-16'
        local params = vim.lsp.util.make_position_params(0, position_encoding)
        vim.lsp.buf_request(0, 'textDocument/hover', params, function(err, res)
          if err or not res or not res.contents then
            vim.notify('No hover', vim.log.levels.INFO)
            return
          end
          local ct = res.contents
          local lines = {}
          if type(ct) == 'table' and ct.value then
            lines = { '```typescript' }
            for l in ct.value:gmatch('[^\r\n]+') do
              if l ~= '```typescript' then
                table.insert(lines, l)
              end
            end
            table.insert(lines, '```')
          end
          if #lines > 0 then
            vim.lsp.util.open_floating_preview(lines, 'markdown', {
              border = 'single',
              max_width = 80,
              focusable = true,
              zindex = 50,
            })
          else
            vim.notify('Empty hover', vim.log.levels.INFO)
          end
        end)
      end, { desc = 'LSP: Hover Documentation' })

      -- Navbuddy keymap
      vim.keymap.set('n', '<leader>nb', ':Navbuddy<CR>', { noremap = true, desc = '[N]av[B]uddy' })
    end,
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}
