local lsp = require "astronvim.utils.lsp"

return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = {
    {
      "<leader>z",
      function() require("zen-mode").toggle() end,
      desc = "ZenMode",
    },
  },
  dependencies = {
    "folke/twilight.nvim",
    keys = { { "<leader>uT", "<cmd>Twilight<cr>", desc = "Toggle Twilight" } },
    cmd = {
      "Twilight",
      "TwilightEnable",
      "TwilightDisable",
    },
    opts = {
      -- context = 5,
      expand = {
        "constructor_definition",
        "function_definition",
        "function_declaration",
        "table_constructor",
        "for_statement",
        "if_statement",
      },
    },
  },
  opts = {
    window = {
      backdrop = 1,
      width = function() return math.min(120, vim.o.columns * 0.70) end,
      height = 0.9,
      options = {
        number = false,
        relativenumber = false,
        foldcolumn = "0",
        list = false,
        showbreak = "NONE",
        -- signcolumn = "no"
      },
    },
    plugins = {
      options = {
        cmdheight = 1,
        laststatus = 0,
      },
      gitsigns = { enabled = true },
      twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
      tmux = { enabled = true }, -- disables the tmux statusline
      -- this will change the font size on kitty when in zen mode
      -- to make this work, you need to set the following kitty options:
      -- - allow_remote_control socket-only
      -- - listen_on unix:/tmp/kitty
      kitty = {
        enabled = true,
        font = "+4", -- font size increment
      },
      -- this will change the font size on alacritty when in zen mode
      -- requires  Alacritty Version 0.10.0 or higher
      -- uses `alacritty msg` subcommand to change font size
      alacritty = {
        enabled = true,
        font = "12.5", -- font size
      },
      -- this will change the font size on wezterm when in zen mode
      -- See alse also the Plugins/Wezterm section in this projects README
      wezterm = {
        enabled = true,
        -- can be either an absolute font size or the number of incremental steps
        font = "+4", -- (10% increase per step)
      },
    },
    on_open = function() -- disable diagnostics and indent blankline
      vim.g.diagnostics_enabled_old = vim.g.diagnostics_enabled
      vim.g.status_diagnostics_enabled_old = vim.g.status_diagnostics_enabled
      vim.g.diagnostics_enabled = false
      vim.g.status_diagnostics_enabled = false
      vim.diagnostic.config(lsp.diagnostics["off"])
      -- vim.g.indent_blankline_enabled_old = vim.g.indent_blankline_enabled
      -- vim.g.indent_blankline_enabled = false
      pcall(vim.cmd.IndentBlanklineDisable)
    end,
    on_close = function() -- restore diagnostics and indent blankline
      vim.g.diagnostics_enabled = vim.g.diagnostics_enabled_old
      vim.g.status_diagnostics_enabled = vim.g.status_diagnostics_enabled_old
      vim.diagnostic.config(lsp.diagnostics[vim.g.diagnostics_enabled and "on" or "off"])
      -- vim.g.indent_blankline_enabled = vim.g.indent_blankline_enabled_old
      pcall(vim.cmd.IndentBlanklineEnable)
    end,
  },
}
