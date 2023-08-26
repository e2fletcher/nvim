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

      dap.adapters["chrome"] = {
        type = "executable",
        executable = {
          command = "node",
          args = {
            require("mason-registry").get_package("vscode-chrome-debug"):get_install_path()
              .. "/out/src/chromeDebug.js",
          },
        },
      }

      local js_config = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**" },
          cwd = "${workspaceFolder}",
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          sourceMaps = true,
          skipFiles = { "<node_internals>/**" },
          cwd = "${workspaceFolder}",
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Current File (pwa-node with ts-node)",
          cwd = vim.fn.getcwd(),
          runtimeArgs = { "--loader", "ts-node/esm" },
          runtimeExecutable = "node",
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

      local js_config_chrome = {
        name = "Debug (Attach) - Remote",
        type = "chrome",
        request = "attach",
        -- program = "${file}",
        -- cwd = vim.fn.getcwd(),
        sourceMaps = true,
        --      reAttach = true,
        trace = true,
        -- protocol = "inspector",
        -- hostName = "127.0.0.1",
        port = 9222,
        webRoot = "${workspaceFolder}",
      }

      for _, language in ipairs { "typescript", "javascript" } do
        if not dap.configurations[language] then
          dap.configurations[language] = js_config
        else
          utils.extend_tbl(dap.configurations[language], js_config)
        end
      end

      for _, language in ipairs { "typescriptreact", "javascriptreact" } do
        if not dap.configurations[language] then
          dap.configurations[language] = js_config_chrome
        else
          utils.extend_tbl(dap.configurations[language], js_config_chrome)
        end
      end
    end,
  },
}
