vim.api.nvim_create_autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name "NvFilePost"

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  desc = "Make q close help, man, quickfix, dap floats",
  callback = function(event)
    if vim.tbl_contains({ "help", "nofile", "quickfix", "rest-nvim.log" }, vim.bo[event.buf].buftype) then
      vim.keymap.set("n", "q", "<Cmd>close<CR>", {
        desc = "Close window",
        buffer = event.buf,
        silent = true,
        nowait = true,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "checkhealth",
    "fugitive*",
    "flow-*",
    "kulala*",
    "rest_nvim_result*",
    "*rest-nvim.log*",
    "dap.log",
    "git",
    "help",
    "lspinfo",
    "netrw",
    "notify",
    "qf",
    "query",
  },
  callback = function()
    vim.keymap.set("n", "q", vim.cmd.close, { desc = "close the current buffer", buffer = true })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
  callback = function(evt)
    vim.keymap.set("n", "q", "<C-w>q", { silent = true, buffer = evt.buf })
  end,
})

-- vim.cmd [[
-- "autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
-- "autocmd BufEnter * call system("tmux rename-window " . require('pleanary').path:new(vim.api.nvim_buf_get_name(0)):make_relative())
-- "autocmd VimLeave * call system("tmux rename-window bash")
-- "autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
-- "set title
-- ]]
