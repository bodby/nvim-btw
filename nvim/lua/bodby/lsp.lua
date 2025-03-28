local lspconfig = require('lspconfig')

--- @type table<string, table> | string[]
local servers = {
  'clangd',
  'nixd',
  'ocamllsp',
  'mesonlsp',
  'tinymist',
  'rust_analyzer',
  ['markdown_oxide'] = {
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    },
  },
  ['hls'] = {
    settings = {
      haskell = {
        maxCompletions = 100,
        checkProject = false,
        checkParents = 'CheckOnSave',
      },
    },
  },
  ['lua_ls'] = {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        -- FIXME: Why won't 'vim.uv' work?
        diagnostics = {
          globals = { 'vim', 'uv' },
        },
        workspace = {
          library = { vim.env.VIMRUNTIME },
          checkThirdParty = false,
        },
        completion = {
          callSnippet = 'Replace',
          keywordSnippet = 'Disable',
          showWord = 'Disable',
        },
        type = {
          weakNilCheck = true,
          weakUnionCheck = true,
        },
        format = { enable = false },
        hint = { enable = false },
        telemetry = { enable = false },
        semantic = { enable = false },
      },
    },
  },
}

--- @type table<string, any>
local diag_config = {
  underline = true,
  virtual_text = false,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'X',
      [vim.diagnostic.severity.WARN] = '!',
      [vim.diagnostic.severity.INFO] = 'i',
      [vim.diagnostic.severity.HINT] = '?',
    }
  },
  float = {
    scope = 'line',
    severity_sort = true,
    header = '',
    source = false,
    prefix = '',
  },
}

local opts = {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  silent = true,
}
for k, v in pairs(servers) do
  if type(v) == 'table' then
    lspconfig[k].setup(vim.tbl_deep_extend('keep', v, opts))
  else
    lspconfig[v].setup(opts)
  end
end

vim.diagnostic.config(diag_config)
