return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
    keys = {
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
        { "<leader>dc", function() require("dap").continue() end,          desc = "Start/Continue" },
        { "<leader>di", function() require("dap").step_into() end,         desc = "Step into" },
        { "<leader>do", function() require("dap").step_over() end,         desc = "Step over" },
        { "<leader>dO", function() require("dap").step_out() end,          desc = "Step out" },
        { "<leader>dx", function() require("dap").terminate() end,         desc = "Stop" },
    },
    init = function()
        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DiagnosticWarn" })
        vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo" })
        vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "Visual" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticError" })
    end,
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup()
        require("debuggers.coreclr")

        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
}
