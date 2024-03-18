return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of importing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  -- { import = "astrocommunity.lsp.lsp-signature-nvim" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.python" },
  -- { import = "astrocommunity.pack.cpp" },
  -- { import = "astrocommunity.pack.cmake" },
  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.programming-language-support.rest-nvim" },
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.utility.noice-nvim" },
}
