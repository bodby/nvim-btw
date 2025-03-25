local M = {
  --- TODO: UI config (icons).
  ui = {
    border = {
      name = 'none',
      characters = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    },
  },

  --- Helpful utility functions.
  lib = { },
}

--- Return whether or not an element exists in an array.
---
--- @generic T
--- @param e T
--- @param xs T[]
--- @return boolean
function M.lib.elem(e, xs)
  for _, v in ipairs(xs) do
    if v == e then
      return true
    end
  end
  return false
end

--- Return whether the string passed is blank (`''`) or `nil`.
---
--- @param str string
--- @return boolean
function M.lib.nil_str(str)
  return not str or str == ''
end

--- Trim a string, returning it without any leading or trailing spaces.
--- This acts only on spaces, not tabs.
---
--- @param str string
--- @return string
function M.lib.trim(str)
  local i1, i2 = 1, #str
  while str:sub(i1, i1) == ' ' do
    i1 = i1 + 1
  end
  while str:sub(i2, i2) == ' ' do
    i2 = i2 - 1
  end
  return str:sub(i1, i2)
  -- if M.lib.nil_str(str) then
  --   return ''
  -- else
  --   return str:match('^%s*(.-)%s*$')
  -- end
end

--- Insert all passed elements into an array.
---
--- @generic T
--- @param xs T[]
--- @param ... T
--- @return T[]
function M.lib.insert_elems(xs, ...)
  local result = xs
  for _, v in ipairs({ ... }) do
    table.insert(result, v)
  end
  return result
end

--- Return a lambda that calls the passed function with the passed arguments.
--- This allows you to pass functions with arguments, rather than just the
--- function as-is.
--- If the passed function has a return value, then it is also returned.
---
--- I don't know how to describe this, honestly.
---
--- @generic T1
--- @generic T2
--- @param fn fun(...: T2): T1
--- @param ... T2
--- @return T2
function M.lib.with_args(fn, ...)
  local args = { ... }
  return function()
    return fn(unpack(args))
  end
end

--- Reverse the order of a list's elements.
---
--- @generic T
--- @param tbl T[]
--- @return T[]
function M.lib.reverse(tbl)
  local result = tbl
  for i1 = 1, math.floor(#tbl / 2) do
    local i2 = #tbl - i1 + 1
    tbl[i1], tbl[i2] = tbl[i2], tbl[i1]
  end
  return result
end

return M
