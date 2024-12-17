dofile(vim.g.base46_cache .. "dap")

vim.fn.sign_define("DapStopped", { text = "󰁖", texthl = "DapStopped" })
vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpointCondition" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint" })

local dap, dv = require "dap", require "dap-view"
dap.listeners.before.attach["dap-view-config"] = function()
  dv.open()
end
dap.listeners.before.launch["dap-view-config"] = function()
  dv.open()
end
dap.listeners.before.event_terminated["dap-view-config"] = function()
  dv.close()
end
dap.listeners.before.event_exited["dap-view-config"] = function()
  dv.close()
end

dap.adapters.codelldb = {
  name = "codelldb",
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}

dap.adapters["chrome"] = {
  type = "executable",
  command = vim.fn.exepath "chrome-debug-adapter",
}

-- Golang

local config_chrome_debug = {
  {
    name = "Chrome debug 9222",
    type = "chrome",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
  },
}

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = {
      require("mason-registry").get_package("js-debug-adapter"):get_install_path() .. "/js-debug/src/dapDebugServer.js",
      "${port}",
    },
  },
}

local config_js_debug = {
  {
    name = "Attach process",
    type = "pwa-node",
    request = "attach",
    -- mode = "remote",
    skipFiles = {
      "<node_internals>/**",
      "node_modules/**",
    },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    address = "127.0.0.1",
    port = 9229,
    cwd = "${workspaceFolder}",
    -- preLaunchTask = "Run adapter inside docker container",
    -- localRoot = "${workspaceFolder}",
    -- remoteRoot = "/app",
    protocol = "inspector",
    restart = true,
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch current with ts-node",
    cwd = "${workspaceFolder}",
    runtimeArgs = {
      "-r",
      "ts-node/register",
    },
    -- runtimeArgs = {
    --   "--loader",
    --   "ts-node/esm",
    -- },
    runtimeExecutable = "node",
    args = {
      "${file}",
    },
    sourceMaps = true,
    protocol = "inspector",
    skipFiles = {
      "<node_internals>/**",
      "node_modules/**",
    },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
  },
  {
    type = "pwa-node",
    request = "launch",
    skipFiles = {
      "<node_internals>/**",
      "node_modules/**",
    },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  -- {
  --   type = "pwa-node",
  --   request = "attach",
  --   name = "Attach",
  --   processId = require("dap.utils").pick_process,
  --   cwd = "${workspaceFolder}",
  -- },
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
    runInTerminal = true,
  },
}

dap.configurations.cpp = dap.configurations.c

for _, filetype in pairs { "javascript", "typescript" } do
  dap.configurations[filetype] = vim.list_extend(dap.configurations[filetype] or {}, config_js_debug)
end

for _, filetype in pairs { "javascriptreact", "typescriptreact", "typescript", "javascript" } do
  dap.configurations[filetype] = vim.list_extend(dap.configurations[filetype] or {}, config_chrome_debug)
end
