require "bodby.config.options"

vim.cmd.colorscheme "dark"

vim.g.mapleader = " "

-- Why does NvChad defer mappings?
vim.schedule(function()
  require "bodby.config.mappings"
end)

vim.api.nvim_create_augroup("status", { })

require("bodby.native.statusline").setup()
require("bodby.native.statuscolumn").setup()
-- require("bodby.native.winbar").setup()
require("bodby.native.tabline").setup()
-- require("bodby.native.folds").setup()
require "bodby.native.commentstring"

---@param plugins string[]
---@param event string
---@param pattern string
local function lazy_load(plugins, event, pattern)
  local augroup = "lazy" .. event:lower() .. pattern

  vim.api.nvim_create_augroup(augroup, { })
  vim.api.nvim_create_autocmd(event, {
    group    = augroup,
    pattern  = pattern,
    callback = function()
      for _, plugin in pairs(plugins) do
        require("bodby.plugins." .. plugin)
      end

      vim.api.nvim_clear_autocmds({
        group = augroup
      })
    end
  })
end

require "bodby.plugins.telescope-nvim"
require "bodby.plugins.alpha-nvim"
require "bodby.plugins.nvim-lspconfig"

lazy_load({
  "blink-cmp",
  -- "indentmini-nvim",
  -- "hlargs-nvim",
  "gitsigns-nvim",
  "smartcolumn-nvim",
  "nvim-treesitter",
  "nvim-align"
}, "BufEnter", "*")

lazy_load({
  "render-markdown"
}, "FileType", "markdown")
