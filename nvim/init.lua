local mappings = require("bodby.mappings")

vim.cmd.colorscheme("bodby")
require("bodby.options")

vim.schedule(function()
  vim.g.mapleader = " "
  mappings.setup()

  require("bodby.lsp")
end)

-- TODO: Move this into native plugin code and set 'clear = false'?
vim.api.nvim_create_augroup("status", { })

-- TODO: Allow these to be configured like other plugins.
-- FIXME: Refactor these files.
require("bodby.native.statusline").setup()
require("bodby.native.statuscolumn").setup()
require("bodby.native.tabline").setup()

--- @type table<string, string>
local plugins = require("bodby.plugins")

--- @type table<string, table<string, string[]>>
local mapped = { }

--- @type table<string, plugin_config>
local config = vim.tbl_map(function(p)
  return require("bodby.plugins." .. p)
end, plugins)

--- Setup the passed plugin, its mappings, and its post function.
--- @param plugin string
local function setup(plugin)
  --- @type plugin_config
  local options = config[plugin]
  assert(options, ("Invalid plugin passed (" .. plugin .. ")"))

  require(plugin).setup(options.opts)
  vim.schedule(function()
    if options.mappings then
      for k, v in pairs(options.mappings) do
        mappings.map(v.modes, k, v.callback, v.opts)
      end
    end

    if options.post then
      options.post()
    end
  end)
end

-- Map plugins to their configured event, or set them up immediately if they
-- don't have one.
for p, o in pairs(config) do
  --- @type boolean
  local has_event = o.event and o.event ~= ""
  if has_event then
    --- @type string
    local pattern = o.pattern and o.pattern ~= "" and o.pattern or "*"
    if not mapped[o.event] then
      mapped[o.event] = { }
    end

    if not mapped[o.event][pattern] then
      mapped[o.event][pattern] = { }
    end

    table.insert(mapped[o.event][pattern], p)
  else
    setup(p)
  end
end

-- Create autocommands for each filetype and pattern group.
for ev, ps in pairs(mapped) do
  for p, vs in pairs(ps) do
    local group = "Lazy" .. ev .. p

    vim.api.nvim_create_augroup(group, { })
    vim.api.nvim_create_autocmd(ev, {
      group = group,
      pattern = p,
      callback = function()
        for _, x in ipairs(vs) do
          setup(x)
          vim.api.nvim_clear_autocmds({ group = group })
        end
      end
    })
  end
end
