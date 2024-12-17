require("nvchad.lsp").diagnostic_config()

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
    float_win_config = {
      border = "solid",
    },
  },
  -- LSP configuration
  server = {
    default_settings = {
      -- rust-analyzer language server configuration
      ["rust-analyzer"] = {},
    },
  },
  -- DAP configuration
  dap = {},
}

vim.g.rustaceanvim.tools.float_win_config.border = "solid"
