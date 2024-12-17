vim.g.rest_nvim = {
  ui = {
    winbar = true,
    keybinds = {
      prev = "<S-Tab>",
      next = "<Tab>",
    },
  },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "http",
  },
  callback = function()
    local wk = require "which-key"
    wk.add {
      { "<leader>rr", "<Cmd>Rest run<cr>", desc = "󱂛  Request run", mode = "n", buffer = true },
      { "<leader>rl", "<Cmd>Rest last<cr>", desc = "󱂛  Request last", mode = "n", buffer = true },
      { "<leader>rc", "<Cmd>Rest curl yank<cr>", desc = "󱂛  Request copy curl", mode = "n", buffer = true },
      {
        "<leader>rC",
        "<Cmd>Rest curl comment<cr>",
        desc = "󱂛  Request comment curl",
        mode = "n",
        buffer = true,
      },
      { "<leader>ro", "<Cmd>Rest open<cr>", desc = "󱂛  Request open", mode = "n", buffer = true },
      { "<leader>rL", "<Cmd>Rest logs<cr>", desc = "󱂛  Request logs", mode = "n", buffer = true },
      {
        "<leader>re",
        "<Cmd>Telescope rest select_env<cr>",
        desc = "󱂛  Request select env",
        mode = "n",
        buffer = true,
      },
    }
  end,
})
