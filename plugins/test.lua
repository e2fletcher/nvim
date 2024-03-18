return {
  {
    "nvim-neotest/neotest",
    ft = { "typescript" },
    keys = {
      {
        "<leader>tr",
        function() require("neotest").run.run() end,
        desc = "Test run",
      },
      -- {
      --   "<leader>tw",
      --   function() require("neotest").watch.toggle(vim.fn.expand "%") end,
      --   desc = "Test watch run",
      -- },
      {
        "<leader>ts",
        function() require("neotest").summary.toggle() end,
        desc = "Test summary",
      },
    },
    dependencies = {
      -- "nvim-neotest/neotest-go",
      -- "nvim-neotest/neotest-python",
      -- "rouge8/neotest-rust",
      "nvim-neotest/neotest-jest",
      {
        "folke/neodev.nvim",
        opts = function(_, opts)
          opts.library = opts.library or {}
          if opts.library.plugins ~= true then
            opts.library.plugins = require("astronvim.utils").list_insert_unique(opts.library.plugins, "neotest")
          end
          opts.library.types = true
        end,
      },
    },
    opts = function()
      return {
        -- your neotest config here
        adapters = {
          -- require "neotest-go",
          -- require "neotest-rust",
          -- require "neotest-python",
          require "neotest-jest",
        },
        -- status = { virtual_text = true },
        -- output = { open_on_run = true },
        watch = {
          enabled = true,
        },
        quickfix = {
          open = function()
            require("trouble").open { mode = "quickfix", focus = false }
            vim.cmd "copen"
          end,
        },
      }
    end,
    config = function(_, opts)
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup(opts)
    end,
  },
  {
    "catppuccin/nvim",
    optional = true,
    ---@type CatppuccinOptions
    opts = { integrations = { neotest = true } },
  },
}
