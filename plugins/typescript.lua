---@diagnostic disable: missing-fields
local utils = require "astronvim.utils"

return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "chrome") end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require "dap"
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            require("mason-registry").get_package("js-debug-adapter"):get_install_path()
              .. "/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }
      local configurations = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file (node)",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach process (node)",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file (node with ts-node)",
          cwd = vim.fn.getcwd(),
          runtimeExecutable = "node_modules/.bin/ts-node",
          -- runtimeArgs = { "--loader", "ts-node/esm" },
          -- runtimeExecutable = "node",
          args = { "${file}" },
          sourceMaps = true,
          protocol = "inspector",
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
      }
      for _, language in ipairs { "typescript", "javascript" } do
        if not dap.configurations[language] then
          dap.configurations[language] = configurations
        else
          utils.extend_tbl(dap.configurations[language], configurations)
        end
      end
    end,
  },
}
