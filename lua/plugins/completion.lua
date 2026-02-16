return {
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = { 'L3MON4D3/LuaSnip' },
    opts = {
      keymap = {
        preset = 'default',
        ['<C-d>'] = { 'scroll_documentation_up' },
        ['<C-f>'] = { 'scroll_documentation_down' },
        ['<C-space>'] = { 'show' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      },
      sources = {
        default = { 'lsp', 'snippets', 'path', 'buffer' },
      },
      snippets = { preset = 'luasnip' },
      completion = {
        documentation = { auto_show = true },
      },
    },
  },

  {
    'L3MON4D3/LuaSnip',
    config = function()
      local ls = require('luasnip')

      ls.config.set_config({
        history = true,
        updateevents = 'TextChanged,TextChangedI',
        enable_autosnippets = true,
      })

      vim.keymap.set({ 'i', 's', 'n' }, '<c-j>', function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true, desc = 'Expand or jump to next placeholder' })

      vim.keymap.set({ 'i', 's' }, '<c-k>', function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true, desc = 'Jump to previous placeholder' })

      vim.keymap.set({ 'i', 's' }, '<c-o>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { desc = 'Cycle LuaSnip choice' })

      -- Custom JS/TS snippets
      local js_and_ts_snippets = {
        ls.parser.parse_snippet('afn', '($1) => {$2}$0'),
        ls.parser.parse_snippet('fn', 'function $1($2) {\n\t$0\n}'),
        ls.parser.parse_snippet('koto', '(typeof $1)[keyof typeof $1]'),
        ls.parser.parse_snippet('dt', '/** @type {$1} */'),
        ls.parser.parse_snippet('dtb', [[/** @type {import("@babylonjs/core")$1} */]]),
        ls.parser.parse_snippet('dti', [[/** @type {import("$1")$2} */]]),
        ls.parser.parse_snippet('d', [[/** $1 */]]),
        ls.parser.parse_snippet('dd', '/**\n * $1\n */'),
        ls.parser.parse_snippet('dp', [[@param {$1} $2]]),
        ls.parser.parse_snippet('dpb', [[@param {import("@babylonjs/core")$1} $2]]),
        ls.parser.parse_snippet('dpi', [[@param {import("$1")$2} $3]]),
        ls.parser.parse_snippet('dr', [[@returns {$1}]]),
        ls.parser.parse_snippet('drb', [[@returns {import("@babylonjs/core")$1}]]),
        ls.parser.parse_snippet('tsi', [[// @ts-ignore]]),
      }
      ls.add_snippets(nil, {
        javascript = js_and_ts_snippets,
        typescript = js_and_ts_snippets,
      })
    end,
  },
}
