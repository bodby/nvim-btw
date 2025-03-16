local M = { }

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

--- @param str string
--- @return boolean
function M.nil_str(str)
  return not str or str == ""
end

return M
