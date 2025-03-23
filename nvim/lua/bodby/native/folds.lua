local lib = require('bodby.shared').lib
local trim = lib.trim
local insert_elems = lib.insert_elems

-- TODO: Per-filetype customizations and replacements, e.g. 'let ... in' in Nix,
--       or disabled foldend text in Markdown.
local M = { }

function M.setup()
  vim.o.foldmethod = 'expr'
  vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.o.foldtext = 'v:lua.require("bodby.native.folds").text()'
end

--- Return a list of pairs of text to highlight and their highlight.
--- Directly usable in 'foldtext' if `v:foldstart` or `v:foldend` is passed.
---
--- https://github.com/neovim/neovim/pull/27217
---
--- @param buffer integer
--- @param row integer
--- @return table<string, string[]> | string
local function fold_line(buffer, row)
  local ok, parser = pcall(vim.treesitter.get_parser, buffer)
  if not ok then
    return vim.fn.foldtext()
  end

  local query = vim.treesitter.query.get(parser:lang(), 'highlights')
  if not query then
    return vim.fn.foldtext()
  end

  --- Text and highlight.
  --- Apparently the highlight (2nd element) can also be a list of strings
  --- rather than just a single string.
  ---
  --- @type { [1]: string, [2]: string | string[] }
  local result = { }

  --- Start column, end column, and capture names and priorities.
  ---
  --- @type { [1]: integer, [2]: integer, [3]: { capture: string, priority: integer } }
  local meta = { }
  local offset = 0

  local language = vim.treesitter.language.get_lang(vim.bo[buffer].filetype)
  local tree = parser:parse({ row - 1, row })[1]

  local line = vim.api.nvim_buf_get_lines(buffer, row - 1, row, true)[1]
  if not line then
    return vim.fn.foldtext()
  end

  for id, node, metadata in query:iter_captures(tree:root(), buffer, row - 1, row) do
    local name = query.captures[id]

    --- @type number
    local priority =
      tonumber(metadata.priority or vim.highlight.priorities.treesitter)

    local _, sc, _, ec = node:range()
    if sc > offset then
      table.insert(result, { line:sub(offset + 1, sc) })
      table.insert(meta, { offset, sc, { { capture = 'Folded', priority = priority } } })
    end

    offset = ec

    local text = line:sub(sc + 1, ec)
    local capture = '@' .. name .. '.' .. language
    table.insert(result, { text })
    table.insert(meta, { sc, ec, {
      { capture = capture, priority = priority }
    } })
  end

  local i = 1
  while i <= #meta do
    local j = i + 1
    while j <= #meta
      and meta[j][1] >= meta[i][1]
      and meta[j][2] <= meta[i][2]
    do
      for k, v in ipairs(meta[i][3]) do
        if not vim.tbl_contains(meta[j][3], v) then
          table.insert(meta[j][3], k, v)
        end
      end
      j = j + 1
    end

    -- Remove overlapping captures/ranges.
    if j > i + 1 then
      table.remove(result, i)
      table.remove(meta, i)
    else
      if #meta[i][3] > 1 then
        table.sort(meta[i][3], function(a, b)
          return a.priority < b.priority
        end)
      end

      result[i][2] = vim.tbl_map(function(tbl)
        return tbl.capture
      end, meta[i][3])
      i = i + 1
    end
  end

  return result
end

--- Expression used in 'foldtext'.
---
--- @return table<string, string[]> | string
function M.text()
  local buffer = vim.api.nvim_get_current_buf()
  local result = fold_line(buffer, vim.v.foldstart)
  local foldend = fold_line(buffer, vim.v.foldend)

  if next(foldend) and foldend[1][1] then
    foldend[1][1] = trim(foldend[1][1])
  end

  result = insert_elems(result,
    { ' ' .. vim.v.foldstart, 'FoldedRange' },
    { ' ... ', 'Folded' },
    { vim.v.foldend .. ' ', 'FoldedRange' })

  -- TODO: Move these to 'M'.
  --       And please don't make this as ugly as it currently is.
  if result[#result - 3] then
    if
      vim.bo[buffer].filetype == 'nix'
      and result[1][1] == 'let'
      or result[2][1] == 'let'
    then
      local whitespace = result[1][1]
      result = {
        { 'let', '@keyword.nix' },
        { ' ' .. vim.v.foldstart, 'FoldedRange' },
        { ' ... ', 'Folded' },
        { vim.v.foldend .. ' ', 'FoldedRange' },
        { 'in', '@keyword.nix' }
      }

      if whitespace ~= 'let' then
        table.insert(result, 1, { whitespace, 'Folded' })
      end
    elseif vim.bo[buffer].filetype ~= 'markdown' then
      for _, v in ipairs(foldend) do
        table.insert(result, v)
      end
    end
  end

  return result
end

return M
