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

end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  jedi_language_server = {},
  ts_ls = {},

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
  automatic_installation = true,
}

-- Configure LSP servers
local lspconfig = require('lspconfig')

-- Setup servers that are configured in the servers table
for server_name, server_config in pairs(servers) do
  lspconfig[server_name].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = server_config,
  }
end

-- Turn on lsp status information
require('fidget').setup()

-- vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#ffffff]]
vim.cmd [[highlight FloatBorder guifg=white guibg=#000000]]

-- vim.o.winborder = "rounded" -- sets for all floating windows tho...


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Keymaps for LSP functionality
local nmap = function(keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end

  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
nmap('<leader>ca', function() vim.lsp.buf.code_action() end, '[C]ode [A]ction')

nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

nmap('<leader>gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

nmap('<leader>gr', function () require('telescope.builtin').lsp_references{ path_display = { "truncate" } } end, '[G]oto [R]eferences' )
nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')

nmap('K', function () vim.lsp.buf.hover({ border = 'single' }) end, 'Hover Documentation')
nmap('<leader>K', function() vim.lsp.buf.signature_help({ border = 'single' }) end, 'Hover Documentation')

-- Lesser used LSP functionality
nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')

nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

nmap('<leader>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, '[W]orkspace [L]ist Folders')
