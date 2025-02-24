-- NOTE: 'else if' is not the same as 'elseif'.
local M = { }

local hl_reset = "%#StatusLine#"

M.modes = setmetatable({
  ["n"]  = "Normal",
  ["no"] = "Normal",
  ["v"]  = "Visual",
  ["V"]  = "Visual",
  [""] = "Visual",
  ["s"]  = "Select",
  ["S"]  = "Select",
  [""] = "Select",
  ["i"]  = "Insert",
  ["ic"] = "Insert",
  ["R"]  = "Replace",
  ["Rv"] = "Replace",
  ["c"]  = "Command",
  ["cv"] = "Command",
  ["r"]  = "Prompt",
  ["rm"] = "Prompt",
  ["r?"] = "Prompt",
  ["!"]  = "Shell",
  ["t"]  = "Shell"
}, {
  __index = function(_, _)
    return "Limbo"
  end
})

M.blocked_fts = {
  "alpha",
  "TelescopePrompt"
}

M.colors = {
  dir            = "Directory",
  file           = "File",
  git_branch     = "Branch",
  git_delta      = "Delta",
  macro          = "Macro",
  error          = "Error",
  warning        = "Warn",
  -- Hints and info (diagnostics).
  misc           = "Misc",
  filetype       = "FileType",
  -- Newline type (CRLF or LF).
  newline        = "NewLine",
  pos            = "Pos",
  percentage     = "Percent"
}

--- 3 billion download JS micro-dependency.
--- Checks if an element exists inside of an array.
--- @generic T
--- @param e T
--- @param xs T[]
--- @return bool
local function elem(e, xs)
  for _, v in ipairs(xs) do
    if v == e then return true end
  end
  return false
end

---@param col string Color name
---@return string Usable statusline highlight string surrounded by "%#...#"
local function stl_hl(col)
  return "%#StatusLine" .. col .. "#"
end

-- TODO: Take in an opts table.
function M.setup()
  -- FIXME: Make this work when 'laststatus' isn't 3.
  vim.opt.laststatus = 3
  vim.opt.statusline = "%!v:lua.require('bodby.native.statusline').active()"

  -- HACK: Don't hide the statusline on certain actions.
  vim.api.nvim_create_autocmd({
    "BufWritePost",
    "BufEnter",
    "ColorScheme",
    "InsertEnter",
    "CmdwinLeave",
    "CmdlineLeave",
    "CmdlineChanged",
    "TextYankPost"
  }, {
    group    = "status",
    callback = function(_)
      vim.schedule(function()
        vim.cmd "redrawstatus"
      end)
    end
  })

  if vim.g.neovide then
    vim.api.nvim_create_autocmd({
      "CmdwinEnter",
      "CmdlineEnter"
    }, {
      group    = "status",
      callback = function(_)
        vim.opt.statusline = " "
      end
    })

    vim.api.nvim_create_autocmd({
      "CmdwinLeave",
      "CmdlineLeave"
    }, {
      group    = "status",
      callback = function(_)
        vim.opt.statusline = "%!v:lua.require('bodby.native.statusline').active()"
      end
    })
  end
end

--- Shows the current mode (optionally) as well as a colored block.
--- @param show_name bool Whether to show the current mode name
--- @return string
local mode = function(show_name)
  local current = M.modes[vim.api.nvim_get_mode().mode]
  local fg_hl   = stl_hl(current .. "FG")
  local bg_hl   = stl_hl(current .. "BG")

  if show_name then
    -- TODO: Make the mode name casing a config option.
    return bg_hl .. " " .. fg_hl .. " :" .. current:lower() .. hl_reset .. " "
  else
    return bg_hl .. " "
  end
end

--- Shows the current file, directory, and a modified symbol.
--- @return string
local path = function()
  -- TODO: Check if vim.go.columns minus the (sum of all the lengths plus the basename of the path)
  --       is less than 0. If so, it means the filename does not fit.
  --       Do the same with the full path (after fnamemodify), and not the basename.
  --       Use the longest mode name length (6 letters) so it doesn't fluctuate between showing
  --       and hiding the directory while you change modes.
  --       Currently only have a hard cap of 70 columns (100) before I hide the filename (path).

  local buffer = vim.api.nvim_get_current_buf()
  local full   = vim.api.nvim_buf_get_name(buffer)
  local file   = vim.fn.fnamemodify(full, ":~:.:t")
  local dir    = vim.fn.fnamemodify(full, ":~:.:h")

  dir = (dir ~= "." and dir .. "/" or "")

  -- TODO: Should I show something when there is no file attached to the buffer?
  if vim.go.columns >= 70 and full ~= "" then
    local modified = (vim.api.nvim_buf_get_option(buffer, "modified") and "'" or "")

    local file_fmt = stl_hl(M.colors.file) .. file .. modified

    if vim.go.columns <= 100 then
      return file_fmt .. " "
    else
      return stl_hl(M.colors.dir) .. dir .. file_fmt .. " "
    end
  else
    return ""
  end
end

--- Shows the branch and number of files added, changed, and modified.
--- @return string
local git_info = function()
  -- TODO: This requires gitsigns.nvim. Should write this as a standalone function using
  --       only Git commands.

  local branch = (vim.b.gitsigns_head ~= nil
    and "#" .. vim.b.gitsigns_head .. " " or "")

  local status = (vim.b.gitsigns_status ~= "" and vim.b.gitsigns_status ~= nil
    and vim.b.gitsigns_status .. " " or "")

  return stl_hl(M.colors.git_branch) .. branch .. stl_hl(M.colors.git_delta) .. status
end

--- Shows the macro register if recording.
--- @return string
local macro_reg = function()
  local reg = vim.fn.reg_recording()
  return (reg ~= "" and stl_hl(M.colors.macro) .. reg or hl_reset)
end

--- Shows current line and column as well as percentage of whole file.
--- @return string
local pos = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- TODO: Use Lua to format the percentage instead of '%p'?
  return
    stl_hl(M.colors.pos) .. " " .. row .. ":" .. col .. stl_hl(M.colors.percentage) .. " %p%% "
end

--- Errors, warnings, and hints and info.
--- @return string
local diagnostics = function()
  local count = vim.diagnostic.count(0)
  local hints = (count[3] ~= nil and count[3] or 0)
  local info  = (count[4] ~= nil and count[4] or 0)

  local errors   = (count[1] ~= nil and stl_hl(M.colors.error) .. " " .. count[1] or "")
  local warnings = (count[2] ~= nil and stl_hl(M.colors.warning) .. " " .. count[2] or "")

  local hints_and_info = (hints + info > 0 and stl_hl(M.colors.misc) .. " " .. hints + info or "")

  return errors .. warnings .. hints_and_info
end

--- The filetype and type of line endings (CRLF or LF).
--- @return string
local filetype = function()
  local filetype = vim.bo.filetype
  local newlines = vim.bo.fileformat

  if elem(filetype, M.blocked_fts) then
    return ""
  elseif filetype == "" then
    -- No filetype isn't blocked because I sometimes use temporary buffers.
    return stl_hl(M.colors.filetype) .. " !none " .. stl_hl(M.colors.newline) .. newlines
  else
    -- TODO: Add a config option to make the first letter uppercase,
    --       using 'filetype:gsub("^%l", string.upper)', or make the whole text uppercase.
    return
      stl_hl(M.colors.filetype) .. " !" .. filetype .. " " .. stl_hl(M.colors.newline) .. newlines
  end
end

M.active = function()
  return table.concat({
    mode(true),
    path(),
    git_info(),
    macro_reg(),
    hl_reset,
    "%=",
    diagnostics(),
    filetype(),
    pos(),
    mode(false)
  })
end

return M
