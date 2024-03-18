---@diagnostic disable: unused-local
-- customize mason plugins
local utils = require "astronvim.utils"

return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "phpactor",
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        -- "prettier",
        -- "stylua",
        "php-cs-fixer",
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      local dap = require "dap"
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        -- "python",
      })
      opts.handlers = {
        php = function(source_name)
          dap.adapters.php = {
            type = "executable",
            ---@diagnostic disable-next-line: undefined-global
            command = vim.fn.exepath "php-debug-adapter",
          }
          dap.configurations.php = {
            {
              type = "php",
              request = "launch",
              name = "Laravel",
              port = 9003,
              pathMappings = {
                ["/var/www/html"] = "${workspaceFolder}",
              },
            },
          }
        end,
      }
    end,
  },
}
