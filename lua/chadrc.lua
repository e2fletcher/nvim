-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  tabufline = {
    enabled = false,
  },
  statusline = {
    theme = "vscode",
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "lsp", "diagnostics", "macro", "cursor", "cwd" },
    modules = {
      macro = function()
        if vim.fn.reg_recording() ~= "" then
          return "%#DiffDelete# " .. "◉ REC (" .. vim.fn.reg_recording() .. ") "
        else
          return ""
        end
      end,
      lsp = function()
        for _, client in ipairs(vim.lsp.get_clients()) do
          if client.attached_buffers[vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)] then
            return (vim.o.columns > 100 and "   [" .. client.name .. "]") or "   "
          end
        end

        return ""
      end,
      diagnostics = function()
        if not rawget(vim, "lsp") then
          return ""
        end

        local err = #vim.diagnostic.get(
          vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0),
          { severity = vim.diagnostic.severity.ERROR }
        )
        local warn = #vim.diagnostic.get(
          vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0),
          { severity = vim.diagnostic.severity.WARN }
        )
        local hints = #vim.diagnostic.get(
          vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0),
          { severity = vim.diagnostic.severity.HINT }
        )
        local info = #vim.diagnostic.get(
          vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0),
          { severity = vim.diagnostic.severity.INFO }
        )

        err = (err and err > 0) and ("%#DiagnosticError#" .. " " .. err .. " ") or ""
        warn = (warn and warn > 0) and ("%#DiagnosticWarn#" .. " " .. warn .. " ") or ""
        hints = (hints and hints > 0) and ("%#DiagnosticHint#" .. "󰛩 " .. hints .. " ") or ""
        info = (info and info > 0) and ("%#DiagnosticInfo#" .. "󰋼 " .. info .. " ") or ""

        return " " .. err .. warn .. hints .. info
      end,
    },
  },
  telescope = {
    style = "borderless",
  },
  cmp = {
    style = "flat_dark",
  },
}

M.colorify = {
  enabled = true,
}

M.mason = {
  pkgs = {
    -- "typescript-language-server",
    "yaml-language-server",
    "lua-language-server",
    "stylua",
    "html-lsp",
    "css-lsp",
    -- Javascript
    "prettierd",
    "eslint-lsp",
    "json-lsp",
    "js-debug-adapter",
    "chrome-debug-adapter",
    "vtsls",
    -- Docker
    "docker-compose-language-service",
    "dockerfile-language-server",
    "hadolint",
    -- Python
    "basedpyright",
    "isort",
    "black",
    -- Go
    "gopls",
    "gomodifytags",
    "iferr",
    "impl",
    "gotests",
    "goimports",
    "delve",
  },
}

M.lsp = {
  signature = true,
}

M.base46 = {
  theme = "flexoki-light",
  hl_add = {
    FlashLabel = {
      bg = "baby_pink",
      bold = true,
      italic = true,
      fg = "darker_black",
    },
    DiffviewFilePanelSelected = { bg = "yellow", fg = "darker_black" },
  },
  hl_override = {
    DiffChangeDelete = { bg = "red", fg = "grey" },
    DiffText = { bg = "yellow", fg = "grey" },
    DiffAdd = { bg = "green", fg = "grey" },
    DiffDelete = { bg = "red", fg = "grey" },
    Boolean = { bold = true },
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    -- ["@string"] = { italic = true },
    ["@variable.builtin"] = { italic = true },
    ["@keyword"] = { italic = true },
  },
  integrations = {
    "telescope",
    "blankline",
    "whichkey",
    "lsp",
    "cmp",
    "git",
    "treesitter",
    "devicons",
    "nvimtree",
    "dap",
    "todo",
    "trouble",
  },
}

return M
