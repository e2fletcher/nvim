vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "markdown",
  },
  callback = function()
    local wk = require "which-key"
    wk.add {
      { "<leader>um", "<Cmd>Markview<CR>", desc = "Toggle markdown view", mode = "n", buffer = true },
    }
  end,
})

return {
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    cmd = { "Markview" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local presets = require "markview.presets"
      require("markview").setup {
        checkboxes = presets.checkboxes.nerd,
        headings = presets.simple,
        hybrid_modes = { "n" },
        list_items = {
          enable = true,

          --- Amount of spaces that defines an indent
          --- level of the list item.
          ---@type integer
          indent_size = 2,

          --- Amount of spaces to add per indent level
          --- of the list item.
          ---@type integer
          shift_width = 4,

          marker_minus = {
            add_padding = true,

            text = "► ",
            hl = "MarkviewListItemMinus",
          },
          marker_plus = {
            add_padding = true,

            text = " ",
            hl = "MarkviewListItemPlus",
          },
          marker_star = {
            add_padding = true,

            text = " ",
            hl = "MarkviewListItemStar",
          },

          --- These items do NOT have a text or
          --- a hl property!

          --- n. Items
          marker_dot = {
            add_padding = true,
          },

          --- n) Items
          marker_parenthesis = {
            add_padding = true,
          },
        },
      }
    end,
  },
}
