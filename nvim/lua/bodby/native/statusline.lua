-- NOTE: 'else if' is not the same as 'elseif'.

--- @alias statusline string

local M = { }

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
  dir        = "Directory",
  file       = "File",
  git_branch = "Branch",
  git_delta  = "Delta",
  macro      = "Macro",
  error      = "Error",
  warning    = "Warn",
  info       = "Info",
  hint       = "Hint",
  filetype   = "FileType",
  -- Newline type (CRLF or LF).
  newline    = "NewLine",
  pos        = "Pos",
  percentage = "Percent"
}

local hl_reset = "%#StatusLine#"

--- 3 billion download JS micro-dependency.
--- Checks if an element exists inside of an array.
--- @generic T
--- @param e T
--- @param xs T[]
--- @return boolean
local function elem(e, xs)
  for _, v in ipairs(xs) do
    if v == e then return true end
  end
  return false
end

--- @param col string Color name
local function stl_hl(col)
  return "%#StatusLine" .. col .. "#"
end

-- TODO: Take in an opts table.
function M.setup()
  -- FIXME: Make this work when 'laststatus' isn't 3.
  vim.o.laststatus = 3
  vim.o.statusline = "%!v:lua.require('bodby.native.statusline').active()"

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

  vim.api.nvim_create_autocmd({
    "CmdwinEnter",
    "CmdlineEnter"
  }, {
    group    = "status",
    callback = function(_)
      vim.o.statusline = " "
    end
  })

  vim.api.nvim_create_autocmd({
    "CmdwinLeave",
    "CmdlineLeave"
  }, {
    group    = "status",
    callback = function(_)
      vim.o.statusline = "%!v:lua.require('bodby.native.statusline').active()"
    end
  })
end

--- Returns the current mode (optionally) as well as a colored block.
--- @param show_name boolean Whether to show the current mode name
--- @return module
local function mode(show_name)
  local current = M.modes[vim.api.nvim_get_mode().mode]
  local fg_hl   = stl_hl(current .. "FG")
  local bg_hl   = stl_hl(current .. "BG")

  if show_name then
    -- TODO: Make the mode name casing a config option.
    return bg_hl .. " " .. fg_hl .. " " .. current:upper() .. " "
  else
    return bg_hl .. " "
  end
end

--- The current file, directory, and a modification indicator.
--- @param buffer bufID The buffer to return the open file of
--- @return module
local function path(buffer)
  -- TODO: Check if 'go.columns' minus the (sum of all the lengths plus the basename of the path)
  --       is less than 0. If so, it means the filename does not fit.
  --       Do the same with the full path (after fnamemodify), and not the basename.
  --       Use the longest mode name length (6 letters) so it doesn't fluctuate between showing
  --       and hiding the directory while you change modes.
  --       Currently only have a hard cap of 70 columns (100) before I hide the filename (path).

  local full = vim.api.nvim_buf_get_name(buffer)
  local file = vim.fn.fnamemodify(full, ":~:.:t")
  local dir  = vim.fn.fnamemodify(full, ":~:.:h")

  dir = dir ~= "." and dir .. "/" or ""

  -- TODO: Should I show something when there is no file attached to the buffer?
  if vim.go.columns >= 70 and full ~= "" then
    local modified = vim.api.nvim_buf_get_option(buffer, "modified") and "'" or ""

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

--- The branch and number of files added, changed, and modified.
--- @return module
local function git_info()
  -- TODO: This requires gitsigns.nvim. Should write this as a standalone function using
  --       only Git commands.

  local branch = vim.b.gitsigns_head ~= nil
    and ("#" .. vim.b.gitsigns_head .. " ") or ""

  local status = vim.b.gitsigns_status ~= nil and (vim.b.gitsigns_status .. " ") or ""

  return stl_hl(M.colors.git_branch) .. branch .. stl_hl(M.colors.git_delta) .. status
end

--- The macro register if recording.
--- @return module
local function macro_reg()
  local reg = vim.fn.reg_recording()
  return reg ~= "" and stl_hl(M.colors.macro) .. reg or hl_reset
end

--- Current line, column, and percentage of whole file.
--- @param window winID The window to get the cursor position from
--- @param ft string The filetype of the window's current buffer
--- @return module
local function pos(window, ft)
  local _, col = unpack(vim.api.nvim_win_get_cursor(window))
  local line = #vim.fn.getline(".")
  if elem(ft, M.blocked_fts) then
    return ""
  else
    -- TODO: Use Lua to format the percentage instead of '%p'?
    return
      stl_hl(M.colors.pos) .. " " .. col .. "/" .. line .. stl_hl(M.colors.percentage) .. " %p%% "
  end
end

--- Errors, warnings, and hints and info.
--- @param buffer bufID The buffer to get the diagnostics of
--- @return module
local function diagnostics(buffer)
  local count = vim.diagnostic.count(buffer)

  local errors   = count[1] ~= nil and (stl_hl(M.colors.error) .. " " .. count[1]) or ""
  local warnings = count[2] ~= nil and (stl_hl(M.colors.warning) .. " " .. count[2]) or ""
  local info     = count[3] ~= nil and (stl_hl(M.colors.info) .. " " .. count[3]) or ""
  local hints    = count[4] ~= nil and (stl_hl(M.colors.hint) .. " " .. count[4]) or ""

  return errors .. warnings .. info .. hints
end

--- The filetype and type of line endings (CRLF or LF).
--- @param buffer bufID The buffer to get the filetype of
--- @return module
local function filetype(buffer)
  local ft       = vim.bo[buffer].filetype
  local newlines = vim.bo[buffer].fileformat

  if elem(ft, M.blocked_fts) then
    return ""
  elseif ft == "" then
    -- No filetype isn't blocked because I sometimes use temporary buffers.
    return stl_hl(M.colors.filetype) .. " none " .. stl_hl(M.colors.newline) .. newlines
  else
    -- TODO: Add a config option to make the first letter uppercase,
    --       using 'filetype:gsub("^%l", string.upper)', or make the whole text uppercase.
    return
      stl_hl(M.colors.filetype) .. " " .. ft .. " " .. stl_hl(M.colors.newline) .. newlines
  end
end

--- Actual statusline used in 'vim.o.statusline'.
--- @return statusline
function M.active()
  local window = vim.api.nvim_get_current_win()
  local buffer = vim.api.nvim_win_get_buf(window)

  return table.concat({
    mode(true),
    path(buffer),
    git_info(),
    macro_reg(),
    hl_reset,
    "%=",
    diagnostics(buffer),
    filetype(buffer),
    pos(window, vim.bo[buffer].filetype),
    mode(false)
  })
end

return M
