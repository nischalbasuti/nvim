local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})

vim.keymap.set({"i", "s", "n"}, "<c-j>", function()
  print(ls.expand_or_jumpable())
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, {silent = true, desc= "Expand or jump to next placeholder"})

vim.keymap.set({"i", "s"}, "<c-k>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, {silent = true, desc = "Jump to previous placeholder"})

vim.keymap.set({"i", "s"}, "<c-o>", function()
  if ls.choice_active() then
    ls.choice_active(1)
  end
end)

vim.keymap.set("n", "<leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")

ls.add_snippets(nil, {
  javascript = {
    ls.parser.parse_snippet("afn", "($1) => {$2}$0"),
    ls.parser.parse_snippet("fn", "function $1($2) {\n\t$0\n}"),

    ls.parser.parse_snippet("dt", "/** @type {$1} */"),
    ls.parser.parse_snippet("dtb", [[/** @type {import("@babylonjs/core")$1} */]]),
    ls.parser.parse_snippet("dti", [[/** @type {import("$1")$2} */]]),

    ls.parser.parse_snippet("d", [[/** $1 */]]),
    ls.parser.parse_snippet("dd", "/**\n * $1\n */"),

    ls.parser.parse_snippet("dp", [[@param {$1} $2]]),
    ls.parser.parse_snippet("dpb", [[@param {import("@babylonjs/core")$1} $2]]),
    ls.parser.parse_snippet("dpi", [[@param {import("$1")$2} $3]]),

    ls.parser.parse_snippet("dr", [[@returns {$1}]]),
    ls.parser.parse_snippet("drb", [[@returns {import("@babylonjs/core")$1}]]),
  }
})


-- local s = ls.s
-- local i = ls.insert_node
-- local fmt = require("luasnip.extras.fmt").fmt
-- local rep = require("luasnip.extras").rep
-- local rep = require("luasnip.extras.")
-- ls.add_snippets(nil, {
--   javascript = {
--     s("cl", fmt("class {} {} ", { i(1, "ClassName") })),
--   }
-- })
-- local date = function() return {os.date('%Y-%m-%d')} end
--
-- ls.add_snippets(nil, {
--     all = {
--         s({
--             trig = "date",
--             namr = "Date",
--             dscr = "Date in the form of YYYY-MM-DD",
--         }, {
--             func(date, {}),
--         }),
--     },
-- })
