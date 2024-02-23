local utils = require "astronvim.utils"
local get_icon = utils.get_icon

return {
  {
    "goolord/alpha-nvim",
    opts = function(_, opts) -- override the options using lazy.nvim
      opts.section.header.val = { -- change the header section value
        "                       _           ",
        " _ __   ___  _____   _(_)_ __ ___  ",
        "| '_ \\ / _ \\/ _ \\ \\ / / | '_ ` _ \\ ",
        "| | | |  __/ (_) \\ V /| | | | | | |",
        "|_| |_|\\___|\\___/ \\_/ |_|_| |_| |_|",
      }
    end,
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astronvim.utils.status"

      opts.statusline = { -- statusline
        hl = { fg = "fg", bg = "bg" },
        status.component.mode { mode_text = { padding = { left = 1, right = 1 } } }, -- add the mode text
        status.component.git_branch(),
        status.component.file_info { filetype = {}, filename = false, file_modified = false },
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.lsp(),
        status.component.treesitter(),
        status.component.nav(),
        -- remove the 2nd mode indicator on the right
      }

      return opts
    end,
  },
  { -- override nvim-cmp plugin
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji", -- add cmp source as dependency of cmp
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
      },
      "f3fora/cmp-spell",
    },
    -- override the options table that is used in the `require("cmp").setup()` call
    opts = function(_, opts)
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      local cmp = require "cmp"
      -- modify the sources part of the options table
      opts.sources = cmp.config.sources {
        {
          name = "spell",
          priority = 1000,
          option = {
            keep_all_entries = false,
            enable_in_context = function() return require("cmp.config.context").in_treesitter_capture "spell" end,
          },
        },
        { name = "cmp_tabnine", priority = 900 }, -- add new source
        { name = "nvim_lsp", priority = 800 }, -- 1000
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "emoji", priority = 300 },
        { name = "path", priority = 250 },
      }

      -- return the new table to be used
      return opts
    end,
  },
  -- customize alpha options
  -- You can disable default plugins as follows:
  -- { "max397574/better-escape.nvim", enabled = false },
  --
  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  -- {
  --   "L3MON4D3/LuaSnip",
  --   config = function(plugin, opts)
  --     require "plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- add more custom luasnip configuration such as filetype extend or custom snippets
  --     local luasnip = require "luasnip"
  --     luasnip.filetype_extend("javascript", { "javascriptreact" })
  --   end,
  -- },
  -- {
  --   "windwp/nvim-autopairs",
  --   config = function(plugin, opts)
  --     require "plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- add more custom autopairs configuration such as custom rules
  --     local npairs = require "nvim-autopairs"
  --     local Rule = require "nvim-autopairs.rule"
  --     local cond = require "nvim-autopairs.conds"
  --     npairs.add_rules(
  --       {
  --         Rule("$", "$", { "tex", "latex" })
  --           -- don't add a pair if the next character is %
  --           :with_pair(cond.not_after_regex "%%")
  --           -- don't add a pair if  the previous character is xxx
  --           :with_pair(
  --             cond.not_before_regex("xxx", 3)
  --           )
  --           -- don't move right when repeat character
  --           :with_move(cond.none())
  --           -- don't delete if the next character is xx
  --           :with_del(cond.not_after_regex "xx")
  --           -- disable adding a newline when you press <cr>
  --           :with_cr(cond.none()),
  --       },
  --       -- disable for .vim files, but it work for another filetypes
  --       Rule("a", "a", "-vim")
  --     )
  --   end,
  -- },
  -- By adding to the which-key config and using our helper function you can add more which-key registered bindings
  {
    "folke/which-key.nvim",
    config = function(plugin, opts)
      require "plugins.configs.which-key"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- Add bindings which show up as group name
      local wk = require "which-key"
      wk.register({
        r = { name = get_icon("Search", 1, true) .. "Requests" },
      }, { mode = "n", prefix = "<leader>" })
    end,
  },
}
