local M = { }

local colors = {
  loc      = "%#WinBarLOC#",
  modified = "%#WinBarMod#",
  fill     = "%#WinBarFill#"
}

-- local blocked_filetypes = {
--   "TelescopePrompt",
--   "blink-cmp-menu",
--   "blink-cmp-documentation",
--   "blink-cmp-signature"
-- }

function M.setup()
  vim.wo.winbar = "%!v:lua.require('bodby.native.winbar').active(0)"

  vim.api.nvim_create_autocmd({
    "WinEnter",
    "BufEnter"
  }, {
    group    = "status",
    callback = function(_)
      local windows = vim.api.nvim_tabpage_list_wins(0);

      for _, window in pairs(windows) do
        -- for _, ft in pairs(blocked_filetypes) do
        --   if vim.bo[vim.api.nvim_win_get_buf(window)].filetype == ft then
        --     return
        --   end
        -- end

        if vim.api.nvim_win_get_config(window).relative ~= "" then
          return
        end

        vim.wo[window].winbar = "%!v:lua.require('bodby.native.winbar').active(" .. window .. ")"
      end
    end
  })
end

local file = function(window)
  local mod_suffix = ""
  local filename   = ""

  if vim.api.nvim_win_is_valid(window) then
    local buffer = vim.api.nvim_win_get_buf(window)

    if vim.api.nvim_buf_get_name(buffer) ~= "" then
      filename = "%t"
    else
      filename = "New file"
    end

    if vim.bo[buffer].modified then
      mod_suffix = colors.modified .. "'"
    end
  end

  return "%##" .. filename .. mod_suffix .. " " .. colors.fill
end

local loc = function(window)
  local buffer = vim.api.nvim_win_get_buf(window)
  local lcount = vim.fn.getbufinfo(buffer)[1].linecount

  if lcount then
    return colors.loc .. " " .. lcount
  else
    return ""
  end
end

M.active = function(window)
  if vim.api.nvim_win_is_valid(window) then
    if vim.bo[vim.api.nvim_win_get_buf(window)].filetype == "alpha" then
      -- TODO: Show actually useful information in the dashboard winbar.
      return colors.fill .. " ── " .. "%##AAAAAAAAAAAlpha " .. colors.fill
    end
  end

  return table.concat({
    file(window),
    "%=",
    loc(window)
  })
end

return M
