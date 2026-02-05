-- LSP settings.
local navic = require("nvim-navic")
local navbuddy = require("nvim-navbuddy")

-- Default border for all LSP floating windows
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })

-- Default border for diagnostics
vim.diagnostic.config({
  float = { border = 'single' },
})

-- Enable the following language servers
local servers = {
  clangd = {},
}

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- LSP keymaps and attach handlers via LspAttach autocommand (Neovim 0.11+)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf

    if client and client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
      navbuddy.attach(client, bufnr)
    end

    -- Buffer-local keymaps
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
      require('telescope.builtin').lsp_references{ path_display = { "truncate" } }
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

-- Setup mason so it can manage external tooling
require('mason').setup({
  PATH = "prepend",
})

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = true,
})

-- Configure LSP servers (Neovim 0.11+ native API)
for server_name, server_config in pairs(servers) do
  vim.lsp.config[server_name] = {
    capabilities = capabilities,
    settings = server_config,
  }
  vim.lsp.enable(server_name)
end

-- Turn on lsp status information
require('fidget').setup()

-- Turn on lsp file operations
require("lsp-file-operations").setup()

vim.cmd [[highlight FloatBorder guifg=white guibg=#000000]]

-- Diagnostic keymaps (global)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Set diagnostic loclist' })

-- Custom hover (workaround for blank hover issue with some servers)
vim.keymap.set('n', 'K', function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/hover', params, function(err, res)
    if err or not res or not res.contents then
      vim.notify("No hover", vim.log.levels.INFO)
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
        zindex = 50
      })
    else
      vim.notify('Empty hover', vim.log.levels.INFO)
    end
  end)
end, { desc = 'LSP: Hover Documentation' })
