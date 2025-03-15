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

return M
