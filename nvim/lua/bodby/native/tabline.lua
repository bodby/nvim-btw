local elem = require("bodby.shared").elem
local M = {
  highlights = {
    tab = "Tab",
    buffer = "Buffer"
  }
}

--- Return whether the window passed is floating or not.
---
--- @param window integer
--- @return boolean
local function is_tiled(window)
  return vim.api.nvim_win_get_config(window).relative == ""
end

--- Return a highlight string.
---
--- @param suffix string
--- @param current boolean
--- @return string
local function hl(suffix, current)
  return "%#TabLine" .. suffix .. (current and "" or "NC") .. "#"
end

function M.setup()
  vim.o.tabline = "%!v:lua.require('bodby.native.tabline').text()"
end

-- TODO: Diagnostics.

--- Reusable function to return a formatted buffer entry.
---
--- @param buffer integer
--- @return string
local function buffer_entry(buffer)
  -- TODO: Format help buffers differently.
  local name = vim.fs.basename(vim.api.nvim_buf_get_name(buffer))
  if vim.bo[buffer].filetype == "alpha" then
    name = "Alpha"
  elseif name == "" then
    name = "New file"
  end

  local current = vim.api.nvim_get_current_buf() == buffer
  return hl(M.highlights.buffer, current) .. " " .. name .. " "
end

--- Reusable function to return a formatted tab entry, showing the number of
--- windows in the tab.
---
--- @param tab integer
--- @return string
local function tab_entry(tab)
  local index = vim.api.nvim_tabpage_get_number
  local current = index(0) == index(tab)
  local windows = vim.api.nvim_tabpage_list_wins(tab)

  local tiled = 0
  for _, v in ipairs(windows) do
    if is_tiled(v) then
      tiled = tiled + 1
    end
  end

  return hl(M.highlights.tab, current) .. " " .. tiled .. " "
end

--- Text used in the tabline.
---
--- @return string
function M.text()
  -- FIXME: Truncate buffers if the screen width is too small.
  local buffers = ""
  local windows = vim.api.nvim_tabpage_list_wins(0)
  local opened = { }
  for _, v in ipairs(windows) do
    if is_tiled(v) then
      local buffer = vim.api.nvim_win_get_buf(v)
      if not elem(buffer, opened) then
        table.insert(opened, buffer)
        buffers = buffers .. buffer_entry(buffer)
      end
    end
  end

  local tabs = ""
  for _, v in ipairs(vim.api.nvim_list_tabpages()) do
    tabs = tabs .. tab_entry(v)
  end

  return buffers .. "%#TabLine#%=" .. tabs
end

return M
