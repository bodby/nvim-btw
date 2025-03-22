local lib = require('bodby.shared').lib
local nil_str = lib.nil_str
local elem = lib.elem

--- @class statusline.module
--- @field text string
--- @field length integer

local M = {
  modes = setmetatable({
    ['n'] = 'Normal',
    ['no'] = 'Normal',
    ['v'] = 'Visual',
    ['V'] = 'Visual',
    -- <C-v> <C-v> in insert mode to get this.
    [''] = 'Visual',
    ['s'] = 'Select',
    ['S'] = 'Select',
    -- <C-v> <C-s> in insert mode to get this.
    [''] = 'Select',
    ['i'] = 'Insert',
    ['ic'] = 'Insert',
    ['R'] = 'Replace',
    ['Rv'] = 'Replace',
    ['c'] = 'Command',
    ['cv'] = 'Command',
    ['r'] = 'Prompt',
    ['rm'] = 'Prompt',
    ['r?'] = 'Prompt',
    ['!'] = 'Shell',
    ['t'] = 'Shell'
  }, {
      __index = function(_, _)
        return 'Limbo'
      end
    }),

  --- The line length and filetype won't be shown if the current buffer's
  --- filetype is one of these.
  blocked_filetypes = {
    'alpha',
    'TelescopePrompt'
  },

  -- Mode highlights are derived from `M.modes`.
  highlights = {
    path = 'Path',
    prefix = 'Prefix',
    cwd = 'CWD',
    branch = 'Branch',
    diff = 'Diff',
    macro = 'Macro',
    -- Current line's column count.
    lines = 'Lines',
    filetype = 'FileType',
    error = 'Error',
    warn = 'Warn',
    info = 'Info',
    hint = 'Hint'
  },

  --- Substitutions for the path module prefix (if there is enough space).
  --- The order here matters; more specific paths should be listed first.
  --- If a path prefix shown isn't here, then the path module will show the
  --- relative path of the open file.
  prefixes = {
    { pattern = '^' .. vim.env.HOME .. '/dev/noots/', replacement = '$nixos/' },
    { pattern = '^' .. vim.env.HOME .. '/dev/nvim/', replacement = '$nvim/' },
    { pattern = '^' .. vim.env.HOME .. '/', replacement = '$home/' },
    { pattern = '^/nix/store/%w+-', replacement = '$store/' },
    { pattern = '^/etc/nixos/', replacement = '$nixos/' },
    { pattern = '^/', replacement = '$root/' }
  }
}

--- Return a highlight string.
---
--- @param suffix string
--- @return string
local function hl(suffix)
  return '%#StatusLine' .. suffix .. '#'
end

function M.setup()
  vim.o.laststatus = 3
  vim.o.statusline = '%!v:lua.require("bodby.native.statusline").text()'

  -- HACK: Don't hide the statusline on certain actions.
  vim.api.nvim_create_autocmd({
    'BufWritePost',
    'BufEnter',
    'ColorScheme',
    'InsertEnter',
    'CmdwinLeave',
    'CmdlineLeave',
    'CmdlineChanged',
    'TextYankPost'
  }, {
    group = vim.api.nvim_create_augroup('status', { clear = false }),
    callback = function(_)
      vim.schedule(function()
        vim.cmd 'redrawstatus'
      end)
    end
  })
end

--- Show a pipe character and optionally the current mode name.
---
--- @param show_name boolean
--- @return statusline.module
local function mode(show_name)
  local current = M.modes[vim.api.nvim_get_mode().mode]
  local highlight = hl(current)

  if show_name then
    return {
      text = highlight .. '| ' .. current:sub(1, 2):upper() .. ' ',
      length = 0
    }
  else
    return { text = highlight .. '|', length = 0 }
  end
end

--- Return the path of the passed buffer's file.
---
--- @param buffer integer
--- @param length integer Length of all other statusline modules.
--- @return string
local function path(buffer, length)
  -- TODO: Rewrite path module.
  local full = vim.api.nvim_buf_get_name(buffer)
  if full == '' then
    return ''
  end

  local modified = vim.api.nvim_get_option_value('modified', { buf = buffer })
  local modified_symbol = modified and "'" or ''
  local highlight = hl(M.highlights.path)

  local prefix = ''
  local cwd = vim.fn.getcwd()
  local suffix = ''

  local e1 = 1
  for _, v in ipairs(M.prefixes) do
    local _, match = full:find(v.pattern)
    if match then
      prefix = v.replacement
      e1 = match + 1
      break
    end
  end

  local e2 = e1 - 1
  local _, match = full:find(cwd, 1, true)
  if match then
    e2 = match + 1
  end

  if full:find(cwd, 1, true) then
    cwd = not nil_str(cwd:sub(e1)) and cwd:sub(e1) .. '/' or ''
  else
    cwd = ''
  end

  local segments = vim.split(cwd, '/', { trimempty = true, plain = true })
  local cwd_prefix = ''
  if next(segments) and not nil_str(cwd) then
    cwd = segments[#segments] .. '/'
    cwd_prefix = table.concat(segments, '/', 1, #segments - 1)
    if #segments > 1 then
      cwd_prefix = cwd_prefix .. '/'
    end
  end

  if cwd == '/' then
    cwd = ''
  end

  suffix = full:sub(math.max(e2 + 1, e1))

  if vim.go.columns - (#cwd + #prefix + #suffix) >= length then
    return table.concat({
      hl(M.highlights.prefix),
      prefix,
      highlight,
      cwd_prefix,
      hl(M.highlights.cwd),
      cwd,
      highlight,
      suffix,
      modified_symbol,
      ' '
    })
  else
    local formatted = vim.fn.fnamemodify(full, ':~:.')
    if vim.go.columns - (#formatted) >= length then
      return highlight .. formatted .. modified_symbol .. ' '
    else
      local file = vim.fn.fnamemodify(full, ':t')
      if vim.go.columns - (#file) >= length then
        return highlight .. file .. modified_symbol .. ' '
      else
        return ''
      end
    end
  end
end

--- Return either the current branch or the status.
--- @param buffer integer
--- @param type 'diff' | 'branch'
--- @return statusline.module
local function git(buffer, type)
  --- @param num integer
  --- @param symbol string
  --- @return string
  local function prefix_diff(num, symbol)
    if num ~= 0 then
      return symbol .. num .. ' '
    else
      return ''
    end
  end

  --- @type table
  local git_info = vim.b[buffer].gitsigns_status_dict
  if not git_info then
    return { text = '', length = 0 }
  end

  if type == 'diff' then
    local a, c, r = git_info.added, git_info.changed, git_info.removed
    if not a or not c or not r then
      return { text = '', length = 0 }
    end

    local highlight = hl(M.highlights.diff)
    local added = prefix_diff(a, '+')
    local changed = prefix_diff(c, '~')
    local removed = prefix_diff(r, '-')
    local diff = added .. changed .. removed

    return { text = highlight .. diff, length = #diff + 1 }
  else
    local highlight = hl(M.highlights.branch)
    local branch = git_info.head

    if branch ~= '' then
      return { text = highlight .. branch .. ' ', length = #branch + 1 }
    else
      return { text = '', length = 0 }
    end
  end
end

--- Return the current macro register if one is being recorded.
---
--- @return statusline.module
local function macro()
  local reg = vim.fn.reg_recording()
  if not nil_str(reg) then
    local highlight = hl(M.highlights.macro)
    return { text = highlight .. reg .. ' ', length = 2 }
  else
    return { text = '', length = 0 }
  end
end

-- TODO: Diagnostics.

--- Return the character count of the current line.
---
--- @return statusline.module
local function line_length()
  -- TODO: Make this get the window cursor position instead of using 'getline'.
  local length = #vim.fn.getline('.')
  local highlight = hl(M.highlights.lines)

  if length then
    return {
      text = highlight .. length .. ' ',
      length = #tostring(length) + 1
    }
  else
    return { text = '', length = 0 }
  end
end

--- Return the filetype, or "none" if it is unset.
---
--- @param buffer integer
--- @return statusline.module
local function filetype(buffer)
  local ft = vim.bo[buffer].filetype
  local highlight = hl(M.highlights.filetype)

  if ft ~= '' then
    return { text = highlight .. ft .. ' ', length = #ft + 1 }
  else
    return { text = highlight .. 'none ', length = 5 }
  end
end

--- Text used in the statusline.
---
--- @return string
function M.text()
  local window = vim.api.nvim_get_current_win()
  local buffer = vim.api.nvim_win_get_buf(window)

  -- Instead of having to recalculate the values twice.
  local _lines = line_length()
  local _filetype = filetype(buffer)
  local _diff = git(buffer, 'diff')
  local _branch = git(buffer, 'branch')

  -- 7 is the combined length of the mode module and the macro register.
  local length = 7 + _diff.length + _branch.length

  local blocked = elem(vim.bo[buffer].filetype, M.blocked_filetypes)
  local file_info = blocked and '' or _lines.text .. _filetype.text
  if not blocked then
    length = length + _lines.length + _filetype.length
  end

  return table.concat({
    mode(true).text,
    path(buffer, length),
    _diff.text,
    macro().text,
    '%#StatusLine#%=',
    file_info,
    _branch.text
  })
end

return M
