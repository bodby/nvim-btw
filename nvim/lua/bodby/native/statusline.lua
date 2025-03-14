--- @class statusline.module
--- @field text string
--- @field length integer

local M = {
  modes = setmetatable({
    ["n"] = "Normal",
    ["no"] = "Normal",
    ["v"] = "Visual",
    ["V"] = "Visual",
    [""] = "Visual",
    ["s"] = "Select",
    ["S"] = "Select",
    [""] = "Select",
    ["i"] = "Insert",
    ["ic"] = "Insert",
    ["R"] = "Replace",
    ["Rv"] = "Replace",
    ["c"] = "Command",
    ["cv"] = "Command",
    ["r"] = "Prompt",
    ["rm"] = "Prompt",
    ["r?"] = "Prompt",
    ["!"] = "Shell",
    ["t"] = "Shell"
  }, {
      __index = function(_, _)
        return "Limbo"
      end
    }),

  blocked_filetypes = {
    "alpha",
    "TelescopePrompt"
  },

  -- Mode highlights are derived from `M.modes`.
  highlights = {
    path = "Path",
    branch = "Branch",
    diff = "Diff",
    macro = "Macro",
    -- Current file line count.
    lines = "Lines",
    filetype = "FileType",
    error = "Error",
    warn = "Warn",
    info = "Info",
    hint = "Hint"
  }
}

--- @param e any
--- @param xs any[]
--- @return boolean
local function elem(e, xs)
  for _, v in ipairs(xs) do
    if v == e then
      return true
    end
  end
  return false
end

--- @param suffix string
--- @return string
local function hl(suffix)
  return "%#StatusLine" .. suffix .. "#"
end

function M.setup()
  vim.o.laststatus = 3
  vim.o.statusline = "%!v:lua.require('bodby.native.statusline').text()"

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
    group = vim.api.nvim_create_augroup("status", { clear = false }),
    callback = function(_)
      vim.schedule(function()
        vim.cmd "redrawstatus"
      end)
    end
  })
end

--- @param show_name boolean
--- @return statusline.module
local function mode(show_name)
  local current = M.modes[vim.api.nvim_get_mode().mode]
  local highlight = hl(current)

  if show_name then
    return {
      text = highlight .. "| " .. current:sub(1, 2):upper() .. " ",
      length = 0
    }
  else
    return { text = highlight .. "|", length = 0 }
  end
end

--- @param buffer integer
--- @param length integer Length of all other statusline modules.
--- @return statusline.module
local function path(buffer, length)
  local full = vim.api.nvim_buf_get_name(buffer)
  --- @type boolean
  if vim.fn.fnamemodify(full, ":~:.:t") == "" then
    return { text = "", length = 0 }
  end

  local formatted = vim.fn.fnamemodify(full, ":~:.")
  local modified = vim.api.nvim_get_option_value("modified", { buf = buffer })
  local modified_symbol = modified and "'" or ""
  local highlight = hl(M.highlights.path)

  if vim.go.columns - (#formatted + 2) >= length then
    return {
      text = highlight .. formatted .. modified_symbol .. " ",
      length = 0
    }
  end

  if vim.go.columns - (#vim.fn.fnamemodify(formatted, ":t") + 2) >= length then
    local file = vim.fn.fnamemodify(full, ":t")
    return {
      text = highlight .. file .. modified_symbol .. " ",
      length = 0
    }
  else
    return { text = "", length = 0 }
  end
end

--- @param buffer integer
--- @param type "diff" | "branch"
--- @return statusline.module
local function git(buffer, type)
  --- @type table
  local git_info = vim.b[buffer].gitsigns_status_dict
  if not git_info then
    return { text = "", length = 0 }
  end

  if type == "diff" then
    local a, c, r = git_info.added, git_info.changed, git_info.removed
    if not a or not c or not r then
      return { text = "", length = 0 }
    end

    local highlight = hl(M.highlights.diff)
    local added = (a ~= 0) and "+" .. a .. " " or ""
    local changed = (c ~= 0) and "~" .. c .. " " or ""
    local removed = (r ~= 0) and "-" .. r .. " " or ""
    local diff = added .. changed .. removed

    return { text = highlight .. diff .. " ", length = #diff + 1 }
  else
    local highlight = hl(M.highlights.branch)
    local branch = git_info.head

    if branch ~= "" then
      return { text = highlight .. branch .. " ", length = #branch + 1 }
    else
      return { text = "", length = 0 }
    end
  end
end

--- @return statusline.module
local function macro()
  local reg = vim.fn.reg_recording()
  if reg ~= "" then
    local highlight = hl(M.highlights.macro)
    return { text = highlight .. reg .. " ", length = 2 }
  else
    return { text = "", length = 0 }
  end
end

-- TODO: Diagnostics.

--- @return statusline.module
local function line_length()
  -- TODO: Make this get the buffer cursor position instead of using 'getline'.
  local length = #vim.fn.getline(".")
  local highlight = hl(M.highlights.lines)

  if length then
    return {
      text = highlight .. length .. " ",
      length = #tostring(length) + 1
    }
  else
    return { text = "", length = 0 }
  end
end

--- @param buffer integer
--- @return statusline.module
local function filetype(buffer)
  local ft = vim.bo[buffer].filetype
  local highlight = hl(M.highlights.filetype)

  if ft ~= "" then
    return { text = highlight .. ft .. " ", length = #ft + 1 }
  else
    return { text = highlight .. "none ", length = 5 }
  end
end

--- @return string
function M.text()
  local window = vim.api.nvim_get_current_win()
  local buffer = vim.api.nvim_win_get_buf(window)

  -- Instead of having to recalculate the values twice.
  local _lines = line_length()
  local _filetype = filetype(buffer)
  local _diff = git(buffer, "diff")
  local _branch = git(buffer, "branch")
  local _macro = macro()

  -- 6 is the combined length of both mode modules.
  local length = 6 + _diff.length + _branch.length + _macro.length

  local blocked = elem(vim.bo[buffer].filetype, M.blocked_filetypes)

  if not blocked then
    length = length + _lines.length + _filetype.length
  end

  local file_info = blocked and "" or _lines.text .. _filetype.text

  return table.concat({
    mode(true).text,
    path(buffer, length).text,
    _diff.text,
    _macro.text,
    "%#StatusLine#%=",
    file_info,
    _branch.text,
    mode(false).text
  })
end

return M
