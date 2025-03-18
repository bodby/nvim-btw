local M = { }

--- Return whether or not an element exists in an array.
---
--- @param e any
--- @param xs any[]
--- @return boolean
function M.elem(e, xs)
  for _, v in ipairs(xs) do
    if v == e then
      return true
    end
  end
  return false
end

--- Return whether the string passed is blank (`""`) or `nil`.
---
--- @param str string
--- @return boolean
function M.nil_str(str)
  return not str or str == ""
end

--- Trim a string, returning it without any leading or trailing whitespace.
---
--- @param str string
--- @return string
function M.trim(str)
  if M.nil_str(str) then
    return ""
  else
    return str:match("^%s*(.-)%s*$")
  end
end

return M
