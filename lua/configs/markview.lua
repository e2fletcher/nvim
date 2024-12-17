dofile(vim.g.base46_cache .. "markview")
local presets = require "markview.presets"

return {
  checkboxes = presets.checkboxes.nerd,
  headings = presets.simple,
  preview = {
    hybrid_modes = { "n" },
  },
  markdown = {
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

        text = "■ ",
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
  },
}
