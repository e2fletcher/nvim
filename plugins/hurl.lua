local prefix = "<leader>r"
local utils = require "astronvim.utils"

vim.cmd [[au BufRead,BufNewFile *.hurl set ft=hurl]]

return {
  {
    "jellydn/hurl.nvim",
    ft = "hurl",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = {
      "HurlRunner",
      "HurlRunnerAt",
      "HurlRunnerToEntry",
      "HurlToggleMode",
      "HurlVerbose",
    },
    opts = {
      -- Show debugging info
      debug = false,
      -- Show response in popup or split
      mode = "split",
      split_position = "right",
      -- Default formatter
      formatters = {
        json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
        html = {
          "prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
          "--parser",
          "html",
        },
      },
    },
    keys = {
      -- Run API request
      -- { prefix .. "r", "<Plug>HurlRunner", desc = "Run request" },
      { prefix .. "v", "<Plug>HurlVerbose", desc = "Run request" },
      { "<leader>A", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
      { "<leader>a", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
      { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
      { "<leader>tm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
      { "<leader>tv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
      -- Run Hurl request in visual mode
      { "<leader>h", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "hurl" })
      end
    end,
  },
}
