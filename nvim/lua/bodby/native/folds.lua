local lib = require('bodby.shared').lib
local insert_elems = lib.insert_elems
-- local trim = lib.trim
-- local nil_str = lib.nil_str

-- Sample config.
-- TODO: Actually implement. And make this a separate plugin.
local _ = {
  --- @class (exact) bodby.folds.Delimiter
  --- @field open string
  ---
  --- The string to add at the end, or `true` to use the text at `v:foldend`.
  --- @field closed string | true
  ---
  --- true: "( ... )))"
  --- false: "( ... ) ) )"
  --- @field spacing boolean
  ---
  --- Padding to apply to the range (##..##).
  --- This is only checked for in the first delimiter.
  ---
  --- left: ( ##.##)
  --- right: (##.## )
  --- true: ( ##.## )
  --- false: (##.##)
  --- @field range_pad 'left' | 'right' | boolean

  --- The character to detect, the character to add if detected, and whether or
  --- not a space should be prepended, e.g. '..2 ]' instead of '..2]'.
  ---
  --- The `tighten` field determines whether spacing should be prepended or not
  --- (does not affect the first delimiter):
  ---
  --- @type table<string, bodby.folds.Delimiter>
  delimiters = {
    parentheses = {
      open = '(',
      closed = ')',
      spacing = false,
      range_pad = false,
    },
    brackets = {
      open = '[',
      closed = ']',
      spacing = true,
      range_pad = true,
    },
    braces = {
      open = '{',
      closed = '}',
      spacing = true,
      range_pad = true,
    },
    angled = {
      open = '<',
      closed = '>',
      spacing = true,
      range_pad = false,
    },
  },

  --- Override delimiters. These can stack, and are loaded in the order they are
  --- defined in.
  ---
  --- @type { filetypes: string[], delimiters: bodby.folds.Delimiter[] }[]
  overrides = {
    -- PERF: Store these in a buffer-scoped variable (b:...) that changes when the
    --       filetype event fires so you don't have to fetch these on every fold.
    {
      filetypes = { 'rust', 'nix', 'c', 'cpp' },
      delimiters = {
        brackets = { closed = '];' },
        braces = { closed = true },
      },
    },
    {
      filetypes = { 'rust' },
      delimiters = {
        brackets = {
          open = '[',
          closed = ']',
          spacing = false,
          range_pad = false,
        },
      },
    },
    {
      filetypes = { 'nix' },
      delimiters = {
        parentheses = { open = '(', closed = ');', tighten = true },
        let = { open = 'let', closed = 'in', tighten = false },
      },
    },
    {
      filetypes = { 'lua' },
      delimiters = {
        fn = { open = 'function', closed = 'end', tighten = false },
      },
    },
  },
  suffixes = {

  },
}

--- @class (exact) FoldSuffix
---
--- Regex used to capture the token you want to match and conditionally append
--- the suffix with (using `string.match()`).
--- If no match is specified, then the value of `suffix` will always be
--- applied.
--- Only set `suffix` to `true` or `false` if you omit this.
--- @field match? string | string[]
---
--- The filetypes that the replacement should act in.
--- If this is `nil`, then the replacement will apply in all filetypes.
--- @field filetypes? string[]
---
--- Whether to check the nth token or last token with -1 (excluding whitespace) to
--- determine whether the replacement should apply.
--- @field position? integer
---
--- Either the text to add at the end of the fold or a boolean to indicate
--- that the fold end position's text should be inserted.
--- The first element is the text, and the second the highlight(s).
--- A function can be passed that takes in the match returned by
--- `string.match()`.
--- @field suffix? { [1]: string, [2]: string | string[] } | boolean | fun(string): { [1]: string, [2]: string | string[] }
---
--- Optional function to rewrite the fold prefix/first token.
--- TODO: Make this take ... instead of a single string and let me use
--- `select(1, ...)` instead to handle multiple captures.
--- @field rewrite? fun(string): string | { [1]: string, [2]: string | string[] }
---
--- TODO:
--- Whether only the match string and suffix should be shown and no other text from
--- the line in the buffer.
--- @field exclusive? boolean

-- TODO: Remove unneeded suffixes.
local M = {
  --- If a match isn't found, then only the ellipsis and fold range are shown.
  ---
  --- @type FoldSuffix[]
  suffixes = {
    -- TODO: Make these work inside Treesitter injections.
    { filetypes = { 'lua' }, suffix = true },
    {
      match = '^let$',
      filetypes = { 'nix' },
      position = 1,
      suffix = { 'in', '@keyword' },
    },
    {
      match = '^let$',
      filetypes = { 'nix' },
      position = -1,
      suffix = { 'in', '@keyword' },
    },
    {
      match = { '^{$', '^%[$' },
      filetypes = { 'c', 'cpp', 'rust', 'nix', 'json' },
      position = -1,
      suffix = true,
    },
    {
      match = '^(#+) ',
      filetypes = { 'markdown' },
      position = 1,
      rewrite = function(str)
        local result = string.rep('#.', #str)
        return { result .. ' ', 'RenderMarkdownHeader' }
      end,
    },
  },

  -- TODO: Per-filetype delimiter spacing option (e.g. Rust shouldn't have
  --       #[... ] and instead #[...]).

  --- The character to detect, the character to add if detected, and whether or
  --- not a space should be prepended, e.g. [ ... ] instead of [...].
  ---
  --- @type { [1]: string, [2]: string, [3]: boolean }[]
  delimiters = {
    { '(', ')', false },
    { '[', ']', true },
    { '{', '}', true },
    { '<', '>', false },
  },
}

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

--- Return matching unclosed delimiters for a line.
---
--- @param buffer integer
--- @param row integer
--- @return string
local function match_delimiters(buffer, row)
  local result = { }
  local line = vim.api.nvim_buf_get_lines(buffer, row - 1, row, true)[1]
  for i = 1, #line do
    local char = line:sub(i, i)
    for _, v in ipairs(M.delimiters) do
      if char == v[1] then
        local spacing = v[3] and ' ' or ''
        table.insert(result, 1, spacing .. v[2])
      elseif char == v[2] then
        table.remove(result)
      end
    end
  end

  -- Remove the first delimiter's spacing if it has one.
  if next(result) ~= nil then
    if #result[1] > 1 then
      result[1] = result[1]:sub(2)
    end
  end
  return table.concat(result)
end

--- Expression used in 'foldtext'.
---
--- @return { [1]: string, [2]: string | string[] } | string
function M.text()
  local buffer = vim.api.nvim_get_current_buf()
  local result = fold_line(buffer, vim.v.foldstart)

  -- local last_token = result[#result][1] or { '', 'Folded' }
  result = insert_elems(result,
    { ' ' .. vim.v.foldstart, 'FoldedRange' },
    { '..', 'Folded' },
    { tostring(vim.v.foldend), 'FoldedRange' },
    { match_delimiters(buffer, vim.v.foldstart), '@punctuation.bracket' })

  -- -- TODO: Count the number of brackets, parentheses, etc. in the line and add
  -- --       the same amount to the end.
  -- --- @param suffix? { [1]: string, [2]: string | string[] } | boolean
  -- local function decorate(suffix)
  --   if suffix == true then
  --     local foldend = fold_line(buffer, vim.v.foldend)
  --     if next(foldend) and foldend[1][1] then
  --       foldend[1][1] = trim(foldend[1][1])
  --     end
  --     for _, v in ipairs(foldend) do
  --       table.insert(result, v)
  --     end
  --   elseif type(suffix) == 'table' then
  --     table.insert(result, suffix)
  --   end
  -- end

  -- --- @param v FoldSuffix
  -- --- @return boolean | nil
  -- local function handle(v, i)
  --   if nil_str(i) then
  --     decorate(v.suffix)
  --     return true
  --   end
  --
  --   local token = v.position == -1 and last_token or result[v.position][1]
  --   local match = token:match(i)
  --   if match then
  --     if type(v.suffix) == 'function' then
  --       decorate(v.suffix(match))
  --     else
  --       decorate(v.suffix)
  --     end
  --     if v.rewrite then
  --       result[v.position] = v.rewrite(match)
  --     end
  --     return true
  --   end
  -- end

  -- for _, v in ipairs(M.suffixes) do
  --   if elem(vim.bo[buffer].filetype, v.filetypes) or next(v.filetypes) == nil then
  --     if type(v.match) == 'table' then
  --       for _, v2 in ipairs(v.match) do
  --         if handle(v, v2) then
  --           break
  --         end
  --       end
  --     elseif handle(v, v.match) then
  --       break
  --     end
  --   end
  -- end
  return result
end

return M
