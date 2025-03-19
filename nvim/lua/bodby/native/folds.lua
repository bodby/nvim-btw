local trim = require("bodby.shared").trim

local M = { }

function M.setup()
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.o.foldtext = "v:lua.require('bodby.native.folds').text()"
end

-- FIXME: I wrote the two functions below on mobile. I think there's an
--        off-by-one error in 'highlight_line()'.
--
--        Or they just don't work entirely.
--
--        The return type annotation on 'highlight_line()' doesn't make sense.

--- Return the last Treesitter capture at a position or 'Folded' if none exist.
---
--- @param buffer integer
--- @param row integer
--- @param col integer
--- @return string
local function get_highlight(buffer, row, col)
  local result = { }
  for _, v in ipairs(vim.treesitter.get_captures_at_pos(buffer, row, col)) do
    if next(v) ~= nil then
      table.insert(result, '@' .. v.capture .. '.' .. v.lang)
    end
  end
  return result[#result] or 'Folded'
end

--- Return a list of pairs of text to highlight and their highlight.
--- Directly usable in 'foldtext' if `vim.v.foldstart` or `foldend` is passed.
---
--- @param buffer integer
--- @param row integer
--- @return table<string>[]
local function highlight_line(buffer, row)
  local result = { }
  local prev = get_highlight(buffer, row, 0)
  local offset = 1

  local line = vim.api.nvim_buf_get_lines(buffer, row - 1, row, true)[1]
  local length = #line
  for i = 1, length do
    local highlight = get_highlight(buffer, row, i - 1)
    if highlight ~= prev then
      table.insert(result, { line:sub(offset, i), prev })
      offset = i 
    else if i == length then
      table.insert(result, { line:sub(-1), prev })
    end
    prev = highlight
  end
  return result
end

--- Expression used in 'foldtext'.
---
--- @return table<string, string>
function M.text()
  -- TODO: Make this per-buffer by passing the window (same with winbar).
  
  return highlight_line(vim.api.nvim_get_current_buf(), vim.v.foldstart)
  -- Highlights can be added if a table is passed instead of just a string.
  -- return {
  --   { line, "Folded" },
  --   { " ... ", "Delimiter" },
  --   { trim(delimiter), "Folded" }
  -- }
end

return M
