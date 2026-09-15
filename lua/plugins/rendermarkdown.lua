return {
    'MeanderingProgrammer/render-markdown.nvim',
    after = { 'nvim-treesitter' },
    requires = { 'nvim-mini/mini.nvim', opt = true },            -- if you use the mini.nvim suite
    -- requires = { 'nvim-mini/mini.icons', opt = true },        -- if you use standalone mini plugins
    -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
    config = function()
        require('render-markdown').setup({
            indent = {
                -- Mimic org-indent-mode behavior by indenting everything under a heading based on the
                -- level of the heading. Indenting starts from level 2 headings onward by default.

                -- Turn on / off org-indent-mode.
                enabled = false,
                -- Additional modes to render indents.
                render_modes = false,
                -- Amount of additional padding added for each heading level.
                per_level = 2,
                -- Heading levels <= this value will not be indented.
                -- Use 0 to begin indenting from the very first level.
                skip_level = 1,
                -- Do not indent heading titles, only the body.
                skip_heading = false,
                -- Prefix added when indenting, one per level.
                icon = '▎',
                -- Priority to assign to extmarks.
                priority = 0,
                -- Applied to icon.
                highlight = 'RenderMarkdownIndent',
            },
        })
    end,
}
