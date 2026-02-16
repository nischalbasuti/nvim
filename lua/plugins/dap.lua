return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'jayp0521/mason-nvim-dap.nvim',
    },
    keys = {
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Add [D]ebugger [B]reakpoint' },
      { '<leader>dc', function() require('dap').continue() end, desc = 'DAP continue' },
      { '<leader>dd', function() require('dap').continue() end, desc = 'DAP continue' },
      { '<leader>dh', function() require('dapui').eval() end, desc = 'DAP eval' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'DAP step into' },
      { '<leader>do', function() require('dap').step_out() end, desc = 'DAP step out' },
      { '<leader>dO', function() require('dap').step_over() end, desc = 'DAP step over' },
      { '<leader>dt', function() require('dap').terminate() end, desc = 'DAP terminate' },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      local dap_vt = require('nvim-dap-virtual-text')

      dap_vt.setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = '<module',
        virt_text_pos = 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })

      dapui.setup({
        icons = { expanded = '▾', collapsed = '▸' },
        mappings = {
          expand = { '<CR>', '<2-LeftMouse>' },
          open = 'o',
          remove = 'd',
          edit = 'e',
          repl = 'r',
          toggle = 't',
        },
        expand_lines = vim.fn.has('nvim-0.7'),
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.25 },
              'breakpoints',
              'stacks',
              'watches',
            },
            size = 40,
            position = 'left',
          },
          {
            elements = { 'repl', 'console' },
            size = 0.25,
            position = 'bottom',
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = 'rounded',
          mappings = { close = { 'q', '<Esc>' } },
        },
        windows = { indent = 1 },
        render = { max_type_length = nil },
      })

      dap.set_log_level('TRACE')

      -- Automatically open/close UI
      dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
      dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
      dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

      vim.g.dap_virtual_text = true

      -- Icons
      vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '⭐️', texthl = '', linehl = '', numhl = '' })

      -- Adapters
      dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = { vim.fn.stdpath('data') .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
      }

      dap.adapters.lldb = {
        type = 'executable',
        command = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/lldb/bin/lldb',
        args = {},
      }

      -- Configurations
      dap.configurations.rust = {
        {
          name = 'Debug Rust',
          type = 'lldb',
          request = 'launch',
          program = '${workspaceFolder}/target/debug/${workspaceRootFolderName}',
          cwd = '${workspaceFolder}',
        },
      }

      dap.configurations.typescript = {
        {
          type = 'node2',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'node2',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
      }

      dap.configurations.javascript = {
        {
          type = 'node2',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'node2',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
      }
    end,
  },
}
