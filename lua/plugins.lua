return {
  "nvim-lua/plenary.nvim",
  {
    "nvchad/ui",
    config = function()
      require "nvchad"
    end,
  },
  {
    "nvchad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  "nvchad/volt", -- optional, needed for theme switcher
  {
    "nvzone/minty",
    cmd = { "Shades", "Huefy" },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/SchemaStore.nvim", -- json schema store
      "yioneko/nvim-vtsls", -- javascript utils
    },
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local opts = require "configs.treesitter"
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = function()
      dofile(vim.g.base46_cache .. "whichkey")
      return {}
    end,
  },

  {
    "echasnovski/mini.files",
    event = "VeryLazy",
    config = function(_, opts)
      local opts = require "configs.mini-files"
      require("mini.files").setup(opts)
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    config = function()
      local opts = require "configs.indent-blankline"
      require("ibl").setup(opts)
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason" },
    opts = function()
      return require "configs.mason"
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "configs.luasnip"
        end,
      },
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "andersevenrud/cmp-tmux",
      },
      {
        "supermaven-inc/supermaven-nvim",
        event = "VeryLazy",
        config = function()
          local opts = require "configs.supermaven"
          require("supermaven-nvim").setup(opts)
        end,
      },
    },
    opts = function()
      return require "configs.cmp"
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    opts = function()
      return require "configs.conform"
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "configs.gitsigns"
    end,
  },

  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      local opts = require "configs.smart-splits"
      require("smart-splits").setup(opts)
    end,
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gvdiffsplit", "Gedit" },
  },

  {
    "rest-nvim/rest.nvim",
    ft = "http",
    config = function()
      require "configs.rest"
      require("telescope").load_extension "rest"
    end,
  },
  {

    "mfussenegger/nvim-dap",
    dependencies = {
      {
        {
          "igorlfs/nvim-dap-view",
          opts = {
            winbar = {
              show = true,
              sections = { "watches", "exceptions", "breakpoints", "threads", "repl" },
              default_section = "breakpoints",
            },
            windows = {
              height = 12,
              terminal = {
                position = "left",
                hide = { "pwa-node" },
                start_hidden = false,
              },
            },
          },
        },
        -- {
        --   "rcarriga/nvim-dap-ui",
        --   dependencies = { "nvim-neotest/nvim-nio" },
        -- },
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    config = function()
      require "configs.dap"
    end,
  },

  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {},
  },

  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    cmd = { "TroubleToggle", "Trouble" },
    opts = function()
      return require "configs.trouble"
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = function()
      return require "configs.noice"
    end,
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "j-hui/fidget.nvim",
    cmd = { "Fidget" },
    event = "VeryLazy",
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope", "TodoLocList", "TodoQuickFix" },
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufRead",
    opts = {
      sign_priority = 1,
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
    },
    config = function()
      local opts = require "configs.neotest"
      require("neotest").setup(opts)
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      local opts = require "configs.surround"
      require("nvim-surround").setup(opts)
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = true,
        },
      },
    },
  },
  { "echasnovski/mini.bufremove", version = "*" },

  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      local opts = require "configs.project"
      require("project_nvim").setup(opts)
      require("telescope").load_extension "projects"
    end,
  },

  -- Javascript
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    event = "BufRead package.json",
  },

  -- Rust
  {
    "mrcjkb/rustaceanvim",
    event = "VeryLazy",
    version = "^6",
    config = function()
      require "configs.rustaceanvim"
    end,
  },

  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    cmd = { "Markview" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local opts = require "configs.markview"
      require("markview").setup(opts)
    end,
  },

  {
    cmd = { "DiffviewOpen" },
    "sindrets/diffview.nvim",
    hooks = {
      diff_buf_read = function(bufnr)
        vim.b[bufnr].view_activated = false
      end,
    },
    config = function()
      local opts = require "configs.diffview"
      require("diffview").setup(opts)
    end,
  },
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    config = function()
      require "configs.barbecue"
    end,
  },
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
  {
    "OXY2DEV/patterns.nvim",
    cmd = { "Patterns" },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
