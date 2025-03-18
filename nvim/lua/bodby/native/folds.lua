local trim = require("bodby.shared").trim

local M = { }

function M.setup()
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.o.foldtext = "v:lua.require('bodby.native.folds').text()"
end

--- @param buffer integer
--- @param row integer
--- @return table<string, string>
local function get_highlighted(buffer, row)
  -- Loop through every character in the folded line.
  -- Also watch vim.inspect_pos(). If it doesn't change, then skip any work and
  -- move onto the next letter.
  --
  -- If it does change, then that means a new highlight is set, and start adding
  -- each character to a table.
  local result = { }
  local token = ""

  local prev = ""
  local line = vim.api.nvim_buf_get_lines(buffer, row - 1, row, true)[1]
  local length = 0
  local offset = 0
  for i = 0, #line do
    local marks = vim.inspect_pos(buffer, row - 1, i)

    if next(marks.treesitter) ~= nil then
      local current = marks.treesitter[#marks.treesitter].hl_group
      if current == prev or prev == "" then
        length = length + 1
      else
        offset = offset + length + 1
        length = 0
        print("------")
        table.insert(result, { token, current })
      end
      prev = current
      token = line:sub(offset, offset + length)
      -- print(offset, length)
      -- print(marks.treesitter[#marks.treesitter].hl_group)
      print(token)
      print(vim.inspect(result))
    end
  end
end

-- get_highlighted(vim.api.nvim_get_current_buf(), 51)

--- Expression used in 'foldtext'.
---
--- @return table<string, string>
function M.text()
  -- TODO: Make this per-buffer, by passing the window (same with winbar).
  --       And also make this somehow retain the normal buffer's highlights (so
  --       folded text isn't a single color/has syntax highlighting).
  local line = vim.fn.getline(vim.v.foldstart)
  local delimiter = vim.fn.getline(vim.v.foldend)

  -- Highlights can be added if a table is passed instead of just a string.
  return {
    { line, "Folded" },
    { " ... ", "Delimiter" },
    { trim(delimiter), "Folded" }
  }
end

return M
