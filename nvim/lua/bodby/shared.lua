local M = {
  --- TODO: UI config (borders, icons, etc.).
  ui = { },
  --- Helpful utility functions.
  lib = { }
}

--- Return whether or not an element exists in an array.
---
--- @param e any
--- @param xs any[]
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

--- Trim a string, returning it without any leading or trailing whitespace.
---
--- @param str string
--- @return string
function M.lib.trim(str)
  if M.lib.nil_str(str) then
    return ''
  else
    return str:match('^%s*(.-)%s*$')
  end
end

--- Insert all passed elements into an array.
---
--- @param xs any[]
--- @param ... any
--- @return any[]
function M.lib.insert_elems(xs, ...)
  local result = xs
  for _, v in ipairs({ ... }) do
    table.insert(result, v)
  end
  return result
end

return M
