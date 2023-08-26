return {
  { "folke/tokyonight.nvim" },
  {
    "machakann/vim-sandwich",
    keys = {
      { "sa", desc = "Add surrounding", mode = { "n", "v" } },
      { "sd", desc = "Delete surrounding" },
      { "sr", desc = "Replace surrounding" },
    },
  },
  {
    "catppuccin/nvim",
    optional = true,
    opts = {
      integrations = {
        alpha = false,
        dashboard = false,
        flash = false,
        nvimtree = false,
        ts_rainbow = false,
        ts_rainbow2 = false,
        barbecue = false,
        indent_blankline = false,
        navic = false,
        dropbar = false,
        aerial = true,
        dap = { enabled = true, enable_ui = true },
        headlines = true,
        mason = true,
        native_lsp = { enabled = true, inlay_hints = { background = false } },
        neotree = true,
        noice = true,
        semantic_tokens = true,
        symbols_outline = true,
        telescope = { enabled = true, style = "nvchad" },
        which_key = true,
        sandwich = true,
      },
    },
  },
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
}
