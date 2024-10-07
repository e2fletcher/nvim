-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "eslint", "docker_compose_language_service", "dockerls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

require("lspconfig.configs").vtsls = require("vtsls").lspconfig -- set default server config, optional but recommended

-- If the lsp setup is taken over by other plugin, it is the same to call the counterpart setup function
require("lspconfig").vtsls.setup {
  on_attach = on_attach,
  -- on_init = on_init,
  -- capabilities = capabilities,
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

-- typescript
-- lspconfig.tsserver.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- }

lspconfig.jsonls.setup {
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

lspconfig.yamlls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  on_new_config = function(config)
    config.settings.yaml.schemas =
      vim.tbl_deep_extend("force", config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  end,
  settings = { yaml = { schemaStore = { enable = false, url = "" } } },
}

-- Python

require("lspconfig").basedpyright.setup {
  on_attach = on_attach,
  basedpyright = {
    before_init = function(_, c)
      if not c.settings then
        c.settings = {}
      end
      if not c.settings.python then
        c.settings.python = {}
      end
      c.settings.python.pythonPath = vim.fn.exepath "python"
    end,
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = "basic",
          autoImportCompletions = true,
          diagnosticSeverityOverrides = {
            reportUnusedImport = "information",
            reportUnusedFunction = "information",
            reportUnusedVariable = "information",
            reportGeneralTypeIssues = "none",
            reportOptionalMemberAccess = "none",
            reportOptionalSubscript = "none",
            reportPrivateImportUsage = "none",
          },
        },
      },
    },
  },
}

-- Go

require("lspconfig").gopls.setup {
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = {
        ST1003 = true,
        fieldalignment = false,
        fillreturns = true,
        nilness = true,
        nonewvars = true,
        shadow = true,
        undeclaredname = true,
        unreachable = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      codelenses = {
        gc_details = true, -- Show a code lens toggling the display of gc's choices.
        generate = true, -- show the `go generate` lens.
        regenerate_cgo = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      buildFlags = { "-tags", "integration" },
      completeUnimported = true,
      diagnosticsDelay = "500ms",
      gofumpt = true,
      matcher = "Fuzzy",
      semanticTokens = true,
      staticcheck = true,
      symbolMatcher = "fuzzy",
      usePlaceholders = true,
    },
  },
}
