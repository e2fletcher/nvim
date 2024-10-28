dofile(vim.g.base46_cache .. "lsp")

local map = vim.keymap.set

local on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
  map("n", "<leader>lh", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>lr", function()
    require "nvchad.lsp.renamer"()
  end, opts "Rename current symbol")

  map("n", "<leader>la", require("fastaction").code_action, opts "LSP Code action")
  map("v", "<leader>la", require("fastaction").range_code_action, opts "LSP Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
end

-- disable semanticTokens
local on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

require("nvchad.lsp").diagnostic_config()

require("lspconfig").lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

require("lspconfig").jsonls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  on_new_config = function(config)
    if not config.settings.json.schemas then
      config.settings.json.schemas = {}
    end
    vim.list_extend(config.settings.json.schemas, require("schemastore").json.schemas())
  end,
  settings = { json = { validate = { enable = true } } },
}

require("lspconfig").yamlls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  on_new_config = function(config)
    config.settings.yaml.schemas =
      vim.tbl_deep_extend("force", config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  end,
  settings = { yaml = { schemaStore = { enable = false, url = "" } } },
}

require("lspconfig.configs").vtsls = require("vtsls").lspconfig
require("lspconfig").vtsls.setup {
  on_attach = on_attach,
  settings = {
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      inlayHints = {
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
    vtsls = {
      enableMoveToFileCodeAction = true,
    },
  },
}

require("lspconfig").eslint.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

require("lspconfig").html.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

require("lspconfig").cssls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}
