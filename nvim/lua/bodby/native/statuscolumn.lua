local M = { }

--- @alias statuscolumn string
--- @alias HPos number
--- @alias MPos number
--- @alias LPos number

M.colors = {
  wrapped = "Virt",
  virtual = "Virt"
}

-- TODO: Take in an opts table.
function M.setup()
  -- vim.wo.statuscolumn = "%!v:lua.require('bodby.native.statuscolumn').active()"

  vim.api.nvim_create_autocmd({
    "WinEnter",
    "BufEnter",
  }, {
    group    = "status",
    callback = function(_)
      local windows = vim.api.nvim_tabpage_list_wins(0);

      for _, window in pairs(windows) do
        if vim.api.nvim_win_get_config(window).relative ~= "" then
          return
        end

        vim.wo[window].statuscolumn =
          "%!v:lua.require('bodby.native.statuscolumn').active(" .. window .. ")"
      end
    end
  })
end

--- @param col string Color name
--- @param cursor boolean Whether to prepend "Cursor" to the highlight name
--- @return highlight
local function stc_hl(col, cursor)
  local c = cursor and "Cursor" or ""
  return "%#" .. c .. "Line" .. col .. "#"
end

--- The HML motion indicators.
--- https://github.com/mawkler/hml.nvim
--- @param window winID
--- @return HPos
--- @return MPos
--- @return LPos
local function hml(window)
  local scrolloff = vim.wo[window].scrolloff
  local buffer    = vim.api.nvim_win_get_buf(window)

  local top    = vim.fn.getwininfo(window)[1].topline
  local bottom = vim.fn.getwininfo(window)[1].botline
  local middle = math.floor((bottom - top) / 2 + top)

  local h = top + scrolloff
  if top == 1 then
    h = 1
  elseif h > middle then
    h = math.max(h, scrolloff)
  end

  local l = bottom - scrolloff
  if bottom >= vim.fn.getbufinfo(buffer)[1].linecount then
    l = vim.fn.getbufinfo(buffer)[1].linecount
  elseif l < middle then
    l = middle
  end

  return h, math.max(middle, h), l
end

--- The relative/absolute line number along with HML indicators.
--- @param window winID
--- @return module
local function line_nr(window)
  local h, m, l = hml(window)

  -- Negative when drawing virtual lines, zero when drawing normal lines, and positive when
  -- drawing wrapped lines.
  if vim.v.virtnum > 0 then
    return stc_hl("Wrapped", vim.v.relnum == 0) .. "%=│"
  elseif vim.v.virtnum < 0 then
    return stc_hl("Wrapped", true) .. "%=│"
  end

  if vim.v.relnum == 0 then
    return "%=" .. vim.v.lnum
  end

  if vim.v.lnum == h then
    return "%=" .. stc_hl("NrSpecial", false) .. "H"
  elseif vim.v.lnum == m then
    return "%=" .. stc_hl("NrSpecial", false) .. "M"
  elseif vim.v.lnum == l then
    return "%=" .. stc_hl("NrSpecial", false) .. "L"
  end

  return "%=" .. vim.v.relnum
end

--- Actual statuscolumn used in 'vim.wo[window].statuscolumn'.
--- @param window winID
--- @return statuscolumn
function M.active(window)
  if vim.api.nvim_win_is_valid(window) then
    if not vim.wo[window].number or not vim.wo[window].relativenumber then
      return ""
    end
  end

  return table.concat({
    "%s",
    line_nr(window),
    " "
  })
end

return M
