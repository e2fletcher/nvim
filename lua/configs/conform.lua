vim.api.nvim_create_user_command("FormatToggle", function(args)
  local is_global = not args.bang
  if is_global then
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    if vim.g.disable_autoformat then
      vim.notify("Autoformat-on-save disabled globally", "info", { title = "conform.nvim" })
    else
      vim.notify("Autoformat-on-save enabled globally", "info", { title = "conform.nvim" })
    end
  else
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    if vim.b.disable_autoformat then
      vim.notify("Autoformat-on-save disabled for this buffer", "info", { title = "conform.nvim" })
    else
      vim.notify("Autoformat-on-save enabled for this buffer", "info", { title = "conform.nvim" })
    end
  end
end, {
  desc = "Toggle autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "html" },
  callback = function(ev)
    vim.bo[ev.buf].formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
})

return {
  formatters_by_ft = {
    go = { "goimports", lsp_format = "last" },
    python = { "black", lsp_format = "last" },
    lua = { "stylua" },
    css = { "eslint", "prettierd", stop_after_first = true },
    json = { "jq" },
    html = { "eslint", "prettierd", stop_after_first = true },
    typescript = { "eslint", "prettierd", stop_after_first = true },
    javascript = { "eslint", "prettierd", stop_after_first = true },
    typescriptreact = { "eslint", "prettierd", stop_after_first = true },
    javascriptreact = { "eslint", "prettierd", stop_after_first = true },
    graphql = { "prettierd", stop_after_first = true },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
}
