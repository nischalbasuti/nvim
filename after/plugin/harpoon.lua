require("harpoon").setup({
    menu = {
        width = 80,
    }
})

vim.keymap.set('n', '<leader>hm', require("harpoon.ui").toggle_quick_menu)
vim.keymap.set('n', '<leader>hh', require("harpoon.ui").toggle_quick_menu)

vim.keymap.set('n', '<leader>ha', require("harpoon.mark").add_file)

vim.keymap.set('n', '<leader>hn', require("harpoon.ui").nav_next)
vim.keymap.set('n', '<leader>hj', require("harpoon.ui").nav_next)

vim.keymap.set('n', '<leader>hp', require("harpoon.ui").nav_prev)
vim.keymap.set('n', '<leader>hk', require("harpoon.ui").nav_prev)

vim.keymap.set('n', '<leader>h1', function () require("harpoon.ui").nav_file(1) end)
vim.keymap.set('n', '<leader>h2', function () require("harpoon.ui").nav_file(2) end)
vim.keymap.set('n', '<leader>h3', function () require("harpoon.ui").nav_file(3) end)
vim.keymap.set('n', '<leader>h4', function () require("harpoon.ui").nav_file(4) end)
vim.keymap.set('n', '<leader>h5', function () require("harpoon.ui").nav_file(5) end)
vim.keymap.set('n', '<leader>h6', function () require("harpoon.ui").nav_file(6) end)
vim.keymap.set('n', '<leader>h7', function () require("harpoon.ui").nav_file(7) end)
vim.keymap.set('n', '<leader>h8', function () require("harpoon.ui").nav_file(8) end)
vim.keymap.set('n', '<leader>h9', function () require("harpoon.ui").nav_file(9) end)
vim.keymap.set('n', '<leader>h0', function () require("harpoon.ui").nav_file(10) end)

require("telescope").load_extension('harpoon')
vim.keymap.set('n', '<leader>ht', ':Telescope harpoon marks<CR>')
