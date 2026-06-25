return {
    "clabby/difftastic.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        -- optional: only needed for :DifftPick
        "folke/snacks.nvim",
    },
    config = function()
        require("difftastic-nvim").setup({
            download = false,              -- Auto-download pre-built binary (default: false)
            vcs = "git",                    -- "jj" (default) or "git"
            highlight_mode = "treesitter", -- "treesitter" (default) or "difftastic"
            hunk_wrap_file = true,          -- Next hunk at last hunk goes to next file
            scroll_to_first_hunk = true,  -- Auto-scroll to first hunk after opening a file (default: true)
            snacks_picker = {
                enabled = true,          -- opt-in snacks.nvim integration (default: false)
                limit = 200,              -- number of revisions/commits to list in :DifftPick
            },
            keymaps = {
                next_file = "]f",
                prev_file = "[f",
                next_hunk = "]c",
                prev_hunk = "[c",
                close = "q",
                focus_tree = "<Tab>",
                focus_diff = "<Tab>",
                select = "<CR>",
                goto_file = "gf",
            },
            tree = {
                width = 40,
                icons = {
                    enable = true,    -- use nvim-web-devicons if available
                    dir_open = "",
                    dir_closed = "",
                },
            },
            highlights = {
                -- Override any highlight group (see Highlight Groups below)
                -- DifftAdded = { bg = "#2d4a3e" },
            },
        })
    end,
}
