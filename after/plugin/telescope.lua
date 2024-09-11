-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    layout_strategy = "vertical",
    path_display={"truncate"},
    file_ignore_patterns = { "node_modules" },
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

  extensions = {
    undo = {
      use_delta = true,
      use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
      side_by_side = true,
      vim_diff_opts = { ctxlen = 4 },
      entry_format = "state #$ID, $STAT, $TIME",
      time_format = "",
      saved_only = false,

      layout_strategy = "horizontal",
      layout_config = {
        preview_height = 0.8,
      },
      mappings = {
        i = {
          ["<cr>"] = require("telescope-undo.actions").yank_additions,
          ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
          ["<C-cr>"] = require("telescope-undo.actions").restore,
          -- alternative defaults, for users whose terminals do questionable things with modified <cr>
          ["<C-y>"] = require("telescope-undo.actions").yank_deletions,
          ["<C-r>"] = require("telescope-undo.actions").restore,
        },
        n = {
          ["y"] = require("telescope-undo.actions").yank_additions,
          ["Y"] = require("telescope-undo.actions").yank_deletions,
          ["u"] = require("telescope-undo.actions").restore,
        },
      },
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require("telescope").load_extension, "file_browser")

pcall(require("telescope").load_extension("ui-select"))

pcall(require("telescope").load_extension("undo"))

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').oldfiles, { desc = '[S]earch [R]ecently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find , { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>tr', require('telescope.builtin').resume, { desc = '[T]elescope [R]esume' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sp', require('telescope.builtin').git_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', ':Telescope keymaps<CR>', { noremap = true, desc='[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set( "n", "<leader>tb", ":Telescope file_browser<CR>", { noremap = true, desc='[F]ile [B]rowser' })

vim.keymap.set( "n", "<leader>gb", ":Telescope git_branches<CR>", { noremap = true, desc='[F]ile [B]rowser' })
vim.keymap.set( "n", "<leader>gc", ":Telescope git_commits<CR>", { noremap = true, desc='[F]ile [B]rowser' })
vim.keymap.set( "n", "<leader>gst", ":Telescope git_status<CR>", { noremap = true, desc='[F]ile [B]rowser' })

vim.keymap.set( "n", "<leader>u", ":Telescope undo<CR>", { noremap = true, desc='[U]ndo tree' })

vim.keymap.set( "v", "<leader>sv", '"zy:Telescope grep_string default_text=<C-r>z<cr>', { noremap = true, desc='[S]earch under [Visual] selection' })
