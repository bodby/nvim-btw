local lspconfig = require("lspconfig")
local caps = require("blink.cmp").get_lsp_capabilities()

-- TODO: TexLab.
--- @type table<string, table> | string[]
local servers = {
  "clangd",
  "nixd",
  "ocamllsp",
  "rust_analyzer",
  "mesonlsp",
  "markdown_oxide",

  ["hls"] = {
    settings = {
      haskell = {
        maxCompletions = 100,
        checkProject = false,
        checkParents = "CheckOnSave"
      }
    }
  },

  ["lua_ls"] = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";")
        },

        diagnostics = {
          globals = { "vim" }
        },

        workspace = {
          library = { vim.env.VIMRUNTIME },
          checkThirdParty = false
        },

        completion = {
          callSnippet = "Replace",
          keywordSnippet = "Disable",
          -- FIXME: Does disabling this fix blink.cmp's "buffer" source?
          showWord = "Disable"
        },

        type = {
          weakNilCheck = true,
          weakUnionCheck = true
        },

        format = { enable = false },
        hint = { enable = false },
        telemetry = { enable = false },
        semantic = { variable = false }
      }
    }
  }
}

--- @type table<string, any>
local diag_config = {
  underline = true,
  virtual_text = false,
  update_in_insert = true,
  severity_sort = true,

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "X",
      [vim.diagnostic.severity.WARN] = "!",
      [vim.diagnostic.severity.INFO] = "i",
      [vim.diagnostic.severity.HINT] = "?"
    }
  },

  float = {
    scope = "line",
    severity_sort = true,
    header = "",
    source = false,
    prefix = ""
  }
}

local opts = { capabilities = caps, silent = true }
for k, v in pairs(servers) do
  if type(v) == "table" then
    lspconfig[k].setup(vim.tbl_deep_extend("force", v, opts))
  else
    lspconfig[v].setup(opts)
  end
end

vim.diagnostic.config(diag_config)
