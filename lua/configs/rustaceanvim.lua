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
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
          extraArgs = {
            "--no-deps",
          },
        },
      },
      -- Enables the use of cargo-watch for faster compilation and running
    },
  },
  -- DAP configuration
  dap = {},
}
