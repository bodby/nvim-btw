local M = {
  highlights = {
    virtual = 'Virt',
    wrapped = 'Wrapped'
  }
}

--- Return a highlight string.
---
--- @param suffix string
--- @param cursor boolean
--- @return string
local function hl(suffix, cursor)
  return '%#' .. (cursor and 'CursorLineNr' or 'LineNr') .. suffix .. '#'
end

function M.setup()
  vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
    group = vim.api.nvim_create_augroup('status', { clear = false }),
    callback = function(_)
      local windows = vim.api.nvim_tabpage_list_wins(0)

      for _, window in pairs(windows) do
        -- Don't apply to floating windows.
        if vim.api.nvim_win_get_config(window).relative ~= '' then
          return
        end

        vim.wo[window].statuscolumn =
          '%!v:lua.require("bodby.native.statuscolumn").text(' .. window .. ')'
      end
    end
  })
end

--- Return the line numbers that correspond to the top, center, and bottom of
--- the screen.
--- These can be jumped to using the H, M, and L motions.
---
--- See https://github.com/mawkler/hml.nvim for the original implementation.
---
--- @param window integer
--- @return [integer, integer, integer]
local function hml(window)
  local scrolloff = vim.wo[window].scrolloff
  local buffer = vim.api.nvim_win_get_buf(window)
  local lines = vim.api.nvim_buf_line_count(buffer)

  local top = vim.fn.getwininfo(window)[1].topline
  local bottom = vim.fn.getwininfo(window)[1].botline
  local middle = math.floor((bottom - top) / 2 + top)

  local h = top + scrolloff
  if top == 1 then
    h = 1
  elseif h > middle then
    h = math.max(h, scrolloff)
  end

  local l = bottom - scrolloff
  if bottom >= lines then
    l = lines
  else
    l = math.max(l, middle)
  end

  return h, math.max(middle, h), l
end

--- Text used in the statuscolumn.
---
--- @param window integer
--- @return string
function M.text(window)
  if vim.api.nvim_win_is_valid(window) then
    if not vim.wo[window].number and not vim.wo[window].relativenumber then
      return ''
    end
  end

  local cursor = (vim.v.relnum == 0)
  local sign = '%s%='

  if vim.v.virtnum > 0 then
    return sign .. hl(M.highlights.wrapped, cursor) .. '| '
  elseif vim.v.virtnum < 0 then
    return sign .. hl(M.highlights.virtual, false) .. '- '
  end

  local highlight = hl('', cursor)

  if vim.v.relnum == 0 then
    return sign .. highlight .. tostring(vim.v.lnum) .. ' '
  end

  -- FIXME: I cannot figure out how to get this to work with folded text.
  --        Sometimes the indicators just disappear.
  --
  --        Maybe this helps:
  --        https://stackoverflow.com/questions/19058016/how-do-i-count-the-number-of-displayed-lines-in-vim
  -- local h, m, l = hml(window)
  -- if vim.v.lnum == h then
  --   return sign .. highlight .. 'H '
  -- elseif vim.v.lnum == m then
  --   return sign .. highlight .. 'M '
  -- elseif vim.v.lnum == l then
  --   return sign .. highlight .. 'L '
  -- end

  if vim.wo[window].relativenumber then
    return sign .. highlight .. tostring(vim.v.relnum) .. ' '
  else
    return sign .. highlight .. tostring(vim.v.lnum) .. ' '
  end
end

return M
