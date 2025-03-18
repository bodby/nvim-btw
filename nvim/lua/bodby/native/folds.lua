local shared = require("bodby.shared")
local trim = shared.trim
local elem = shared.elem

local M = { }

function M.setup()
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.o.foldtext = "v:lua.require('bodby.native.folds').text()"
end

--- Expression used in 'foldtext'.
---
--- @return table<string, string>
function M.text()
  -- TODO: Make this per-buffer, by passing the window (same with winbar).
  local line = vim.fn.getline(vim.v.foldstart)
  local delimiter = vim.fn.getline(vim.v.foldend)

  -- get_captures_at_pos(buffer, row, col)
  local capture = vim.treesitter.get_captures_at_pos(0, vim.v.foldstart - 1, 1)

  local highlight = ""
  if next(capture) ~= nil then
    local last = capture[#capture]
    highlight = "@" .. last.capture .. "." .. last.lang
  end

  -- Highlights can be returned if a table is passed instead of just a string.
  return {
    -- { line, highlight },
    { line, "" },
    { " ... ", "Folded" },
    { trim(delimiter), "Delimiter" }
  }
end

-- https://github.com/kevinhwang91/nvim-ufo/blob/main/lua/ufo/render/match.lua
local function get_hls()
  local result = { }
  local window = vim.api.nvim_get_current_win()
  for _, v in pairs(vim.fn.getmatches(window)) do

  end
end

-- PERF: This is insanely expensive.
-- Trying to figure out how to highlight individual tokens.
local function pain()
  local skip = { }
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local buffer = vim.api.nvim_get_current_buf()

  local line = vim.api.nvim_buf_get_lines(buffer, row - 1, row, false)
  vim.treesitter.get_parser(buffer):parse(false)
  if next(line) ~= nil then
    local l = line[1]
    for i = 1, #l do
      local _, b, _, d = vim.treesitter.get_node_range(vim.treesitter.get_node({
        bufnr = buffer,
        pos = { row - 1, i }
      }))

      if not elem(b .. "." .. d, skip) then
        table.insert(skip, b .. "." .. d)
        local token = l:sub(b, d)

        local highlight = vim.treesitter.get_captures_at_pos(buffer, row - 1, i)
        if highlight[#highlight] then
          print(highlight[#highlight].capture .. " for " .. token)
        end
      end
    end
  end
end

return M
