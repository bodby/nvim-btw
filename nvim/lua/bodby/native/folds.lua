local lib = require('bodby.shared').lib
local trim = lib.trim
local insert_elems = lib.insert_elems

local M = { }

function M.setup()
  vim.o.foldmethod = 'expr'
  vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.o.foldtext = 'v:lua.require("bodby.native.folds").text()'
  vim.api.nvim_set_hl(0, 'FoldedRange', { link = 'Folded', default = true })
end

--- Return a list of pairs of text to highlight and their highlight.
--- Directly usable in 'foldtext' if `v:foldstart` or `v:foldend` is passed.
---
--- https://github.com/neovim/neovim/pull/27217
---
--- @param buffer integer
--- @param row integer
--- @return table<string>[]
local function fold_line(buffer, row)
  local ok, parser = pcall(vim.treesitter.get_parser, buffer)
  if not ok then
    return vim.fn.foldtext()
  end

  local query = vim.treesitter.query.get(parser:lang(), 'highlights')
  if not query then
    return vim.fn.foldtext()
  end

  --- @type { [1]: string, [2]: string }[]
  local result = { }
  --- @type { [1]: integer, [2]: integer }[]
  local ranges = { }
  local offset = 0

  local language = vim.treesitter.language.get_lang(vim.bo[buffer].filetype)
  local tree = parser:parse({ row - 1, row })[1]

  local line = vim.api.nvim_buf_get_lines(buffer, row - 1, row, true)[1]
  if not line then
    return vim.fn.foldtext()
  end

  for id, node, _ in query:iter_captures(tree:root(), buffer, row - 1, row) do
    local name = query.captures[id]

    local sr, sc, er, ec = node:range()
    if sc > offset then
      table.insert(result, { line:sub(offset + 1, sc), 'Folded' })
      table.insert(ranges, { offset, sc })
    end
    offset = ec

    local text = line:sub(sc + 1, ec)
    local highlight = '@' .. name .. '.' .. language
    table.insert(result, { text, highlight })
    table.insert(ranges, { sc, ec })
  end

  -- Remove overlapping "tokens".
  local i = 1
  while i <= #result do
    local j = i + 1
    while j <= #result
      and ranges[j][1] >= ranges[i][1]
      and ranges[j][2] <= ranges[i][2]
    do
      j = j + 1
    end

    if j > i + 1 then
      table.remove(result, i)
    else
      i = i + 1
    end
  end

  return result
end

-- FIXME: Breaks when there are pointer or array params in C, e.g. 'int* foo'.

--- Expression used in 'foldtext'.
---
--- @return table<string>[]
function M.text()
  local buffer = vim.api.nvim_get_current_buf()
  local result = fold_line(buffer, vim.v.foldstart)
  local foldend = fold_line(buffer, vim.v.foldend)

  if foldend then
    foldend[1][1] = trim(foldend[1][1])
  end

  result = insert_elems(result,
    { ' ' .. vim.v.foldstart, 'FoldedRange' },
    { ' ... ', 'Folded' },
    { vim.v.foldend .. ' ', 'FoldedRange' })

  -- Prettier Nix folds. Sometimes.
  -- TODO: Make this disable fold end in certain filetypes, e.g. Markdown,
  --       because it doesn't work well there.
  if result[#result - 3][1] == "let" then
    table.insert(result, { 'in', '@keyword.nix' })
  else
    for _, v in ipairs(foldend) do
      table.insert(result, v)
    end
  end

  return result
end

return M
