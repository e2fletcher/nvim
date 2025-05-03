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
  map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")
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

vim.lsp.config("*", { capabilities = capabilities, on_init = on_init })

-- lua
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
        },
      },
    },
  },
})

-- rust
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
      cargo = {
        allFeatures = true,
      },
      procMacro = {
        enable = true,
      },
      diagnostics = {
        disabled = { "unresolved-proc-macro" },
      },
    },
  },
})

-- go
vim.lsp.config("gopls", {
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
})

-- json
vim.lsp.config("jsonls", {
  on_new_config = function(config)
    if not config.settings.json.schemas then
      config.settings.json.schemas = {}
    end
    vim.list_extend(config.settings.json.schemas, require("schemastore").json.schemas())
  end,
  settings = { json = { validate = { enable = true } } },
})

-- yaml
vim.lsp.config("yamlls", {
  on_new_config = function(config)
    config.settings.yaml.schemas =
      vim.tbl_deep_extend("force", config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  end,
  settings = { yaml = { schemaStore = { enable = false, url = "" } } },
})

require("lspconfig.configs").vtsls = require("vtsls").lspconfig

-- typescript
vim.lsp.config("vtsls", {
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
})

-- eslint
vim.lsp.config("eslint", {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function(event)
        if vim.g.disable_autoformat or vim.b[event.buf].disable_autoformat then
          return
        end
        vim.cmd "EslintFixAll"
      end,
    })
  end,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    workingDirectories = { mode = "auto" },
    useFlatConfig = false, -- WARNING: Error with projen projects config old format https://github.com/projen/projen/issues/3950
    format = { enable = true },
  },
})

-- c and c++
vim.lsp.config("clangd", {
  capabilities = vim.tbl_extend("force", capabilities, {
    offsetEncoding = { "utf-8", "utf-16" },
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
  }),
})

vim.lsp.config("basedpyright", {
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
})

vim.lsp.config("tailwindcss", {
  root_dir = function(fname)
    local root_pattern = require("lspconfig").util.root_pattern

    -- First, check for common Tailwind config files
    local root = root_pattern(
      "tailwind.config.mjs",
      "tailwind.config.cjs",
      "tailwind.config.js",
      "tailwind.config.ts",
      "postcss.config.js",
      "config/tailwind.config.js",
      "assets/tailwind.config.js"
    )(fname)
    -- If not found, check for package.json dependencies
    if not root then
      local package_root = root_pattern "package.json"(fname)
      if package_root then
        local package_data = require("utils").decode_json_file(package_root .. "/package.json")
        if
          package_data
          and (
            require("utils").has_nested_key(package_data, "dependencies", "tailwindcss")
            or require("utils").has_nested_key(package_data, "devDependencies", "tailwindcss")
          )
        then
          root = package_root
        end
      end
    end
    return root
  end,
})

vim.lsp.config("emmet_ls", {
  filetypes = {
    "css",
    "eruby",
    "html",
    "javascript",
    "javascriptreact",
    "less",
    "sass",
    "scss",
    "svelte",
    "pug",
    "typescriptreact",
    "vue",
  },
  init_options = {
    html = {
      options = {
        -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
        ["bem.enabled"] = true,
      },
    },
  },
})

-- GraphQL
vim.lsp.config("graphql", {
  settings = {
    graphql = {
      validate = true,
      validateAll = true,
      lint = true,
      completion = true,
      completionType = "schema",
      schema = {
        [".graphql"] = "graphql-config-raw",
        [".graphqlconfig"] = "graphql-config",
        [".gql"] = "graphql-config-raw",
        [".gqlconfig"] = "graphql-config",
      },
      -- experimental: Enable experimental features
      experimental = {
        -- Enable experimental schema validation
        schemaValidation = true,
        -- Enable experimental fragment autocompletion
        fragmentAutocompletion = true,
        -- Enable experimental query autocompletion
        queryAutocompletion = true,
        -- Enable experimental validation for queries
        queryValidation = true,
      },
      extensions = {
        [".graphql"] = "graphql",
        [".graphqlconfig"] = "json",
        [".gql"] = "graphql",
        [".gqlconfig"] = "json",
      },
    },
  },
})

vim.lsp.enable {
  "lua_ls",
  "rust_analyzer",
  "gopls",
  "jsonls",
  "yamlls",
  "vtsls",
  "eslint",
  "clangd",
  "basedpyright",
  "tailwindcss",
  "emmet_ls",
  "graphql",
  "html",
  "cssls",
}
