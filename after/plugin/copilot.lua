-- Copilot.lua configuration for Avante integration
require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<C-L>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  panel = {
    enabled = true,
    auto_refresh = true,
  },
  filetypes = {
    markdown = true,
    help = true,
  },
  copilot_node_command = "node",
  server_opts_overrides = {},
}) 