--- @module "bodby.plugins"

--- @class plugin_config
--- @field event? string
--- @field pattern? string
---
--- Mappings that get created after the plugin is configured.
--- These are deferred using `vim.schedule()`.
--- @field mappings? table<string, mapping>
---
--- Per-plugin configuration options. These are passed to `setup()`.
--- @field opts table
---
--- Called after the plugin is setup.
--- These are deferred using `vim.schedule()`.
--- @field post? fun()

return {
  ["blink.cmp"] = "blink-cmp",
  ["alpha"] = "alpha",
  ["telescope"] = "telescope",
  ["gitsigns"] = "gitsigns",
  ["nvim-treesitter.configs"] = "nvim-treesitter",
  ["render-markdown"] = "render-markdown"

  -- TODO
  -- ["smartcolumn"] = "smart-column",
  -- ["virt-column"] = "virt-column"
}
