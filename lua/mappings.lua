local map = vim.keymap.set

map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "change theme" })

map({ "n", "x", "o" }, "H", "^")
map({ "n", "x", "o" }, "L", "$")

map("n", "<Tab>", "<Cmd>bn!<CR>", { desc = "next buffer" })
map("n", "<S-Tab>", "<Cmd>bp!<CR>", { desc = "previous buffer" })

map({ "n" }, "<leader>uc", require("minty.shades").open, { desc = "Shades color" })
map({ "n" }, "<leader>uC", require("minty.huefy").open, { desc = "Shades color" })

map("n", "-", function()
  local files = require "mini.files"
  if not files.close() then
    files.open(vim.fn.expand "%")
  end
  files.reveal_cwd()
end, { desc = "open directory" })

map("n", "<leader>c", function()
  require("mini.bufremove").delete()
end, { desc = "Close buffer" })

map({ "n", "t" }, "<c-space>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatingTerm" }
end)

map({ "n", "t" }, "<F4>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatingTerm" }
end)

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "find files" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "live grep" })
map("v", "<leader>fw", '"zy:Telescope live_grep default_text=<c-r>z<CR>', { desc = "live grep in visual mode" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "find all files" }
)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "find buffers" })
map("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "find projects" })
map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "telescope show terms" })
map("n", "<leader>fW", "<cmd>Telescope grep_string word_to_search=true<cr>", { desc = "Find word in files" })

-- resize windows
map({ "n", "t" }, "<c-left>", require("smart-splits").resize_left)
map({ "n", "t" }, "<c-down>", require("smart-splits").resize_down)
map({ "n", "t" }, "<c-up>", require("smart-splits").resize_up)
map({ "n", "t" }, "<c-right>", require("smart-splits").resize_right)
-- moving between splits
map("n", "<c-h>", require("smart-splits").move_cursor_left, { desc = "move left window" })
map("n", "<c-j>", require("smart-splits").move_cursor_down, { desc = "move down window" })
map("n", "<c-k>", require("smart-splits").move_cursor_up, { desc = "move up window" })
map("n", "<c-l>", require("smart-splits").move_cursor_right, { desc = "move right window" })

map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

map("n", "<leader>gg", "<cmd>Git<cr>", { desc = "Git" })
map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
map("n", "<leader>hh", require("gitsigns").preview_hunk_inline, { desc = "Preview hunk" })
map("n", "<leader>gs", ":Gitsigns stage_hunk<CR>")
map("v", "<leadergs", ":Gitsigns stage_hunk<CR>")
map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>")
map("v", "<leader>gr", ":Gitsigns reset_hunk<CR>")
map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>")
map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>")
map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>")
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>")
map("n", "<leader>gD", "<cmd>Gitsigns diffthis<CR>")
map("n", "<leader>gd", '<cmd>lua require"gitsigns".diffthis("~")<CR>')
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
map("t", "<esc>", "<C-\\><C-n>", { desc = "terminal escape terminal mode" })

map("n", "<leader>q", "<cmd>q!<cr>", { desc = "Quit window" })

-- dap
map("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "toggle breakpoint" })
map("n", "<leader>dc", require("dap").continue, { desc = "debug continue" })
map("n", "<leader>dC", require("dap").run_to_cursor, { desc = "run to cursor" })
map("n", "<leader>dt", require("dap").terminate, { desc = "debug terminate" })
map("n", "<leader>dr", "<cmd>DapViewJump repl<CR>", { desc = "debug repl toggle" })
map("n", "<leader>du", require("dap-view").toggle, { desc = "Toggle nvim-dap-view" })
map("n", "<leader>dK", function()
  require("dap.ui.widgets").hover(nil, { border = "solid" })
end, { desc = "debug hover" })
map("n", "<leader>ds", function()
  local widgets = require "dap.ui.widgets"
  widgets.centered_float(widgets.scopes, { border = "solid" })
end, { desc = "Window scopes" })
map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "breakpoint condition" })

map("n", "<leader>X", "<cmd>Trouble diagnostics toggle focus=true<cr>", { desc = "Diagnostics (Trouble)" })
map(
  "n",
  "<leader>xx",
  "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
  { desc = "Diagnostics Buffer (Trouble)" }
)
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map(
  "n",
  "<leader>xl",
  "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
  { desc = "LSP Definitions / references / ... (Trouble)" }
)
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

map("n", "<leader>xt", "<cmd>TodoTrouble<cr>", { desc = "Todo (Trouble)" })

map({ "n", "x", "o" }, "s", require("flash").jump, { desc = "Flash" })
map({ "n", "x", "o" }, "<leader>s", require("flash").treesitter, { desc = "Flash Treesitter" })
map({ "x", "o" }, "r", require("flash").treesitter_search, { desc = "Flash Treesitter Search" })

-- Neotest
map("n", "<leader>tt", require("neotest").run.run, { desc = "Run test" })
map("n", "<leader>td", function()
  require("neotest").run.run { strategy = "dap" }
end, { desc = "Debug test" })
map("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Run all test file" })
map("n", "<leader>ts", require("neotest").summary.toggle, { desc = "Summary test" })
map("n", "<leader>tp", require("neotest").output.open, { desc = "Preview test" })
map("n", "<leader>tP", require("neotest").output_panel.toggle, { desc = "Preview all test" })
map("n", "[t", require("neotest").jump.prev, { desc = "Jump prev test" })
map("n", "]t", require("neotest").jump.next, { desc = "Jump next test" })

map("n", "<leader>un", require("utils").number, { desc = "Toggle numbers" })
map("n", "<leader>us", require("utils").spell, { desc = "Toggle spell" })
map("n", "<leader>uw", require("utils").wrap, { desc = "Toggle wrap" })
map("n", "<leader>up", require("utils").autopairs, { desc = "Toggle autopair" })
map("n", "<leader>uf", "<cmd>FormatToggle!<cr>", { desc = "autoformat toggle buffer" })
map("n", "<leader>uF", "<cmd>FormatToggle<cr>", { desc = "autoformat toggle global" })
