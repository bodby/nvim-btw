local with_args = require('bodby.shared').lib.with_args
local builtin = require('telescope.builtin')

local options = {
  --- How much padding should be added to the top of the dashboard, as a
  --- percentage of the screen width.
  --- @type number
  top_margin = 0.28,

  --- Width of the dashboard in columns.
  --- @type integer
  width = 48,

  --- The text shown in the header.
  --- Can be a single string or a list of strings for multiple lines.
  --- @type string[] | string
  header = {
    '           ▄ ▄                   ',
    '       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ',
    '       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ',
    '    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ',
    '  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ',
    '  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄',
    '▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █',
    '█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █',
    '    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    '
  },

  --- The text shown in the footer.
  --- Can be a single string or a list of strings for multiple lines.
  --- @type string[] | string
  footer = 'Sent from my iPhone',

  --- The character used as a prefix for each button.
  --- @type string
  button_char = '*'
}

local function button(shortcut, text, action)
  local mapping_opts = {
    noremap = true,
    silent = true,
    nowait = true
  }

  local opts = {
    position = 'center',
    shortcut = shortcut,
    cursor = 0,
    width = options.width,
    shrink_margin = true,
    align_shortcut = 'right',
    hl_shortcut = 'AlphaShortcut',
    hl = {
      { 'AlphaButtons', 0, 2 },
      { 'AlphaHeaderLabel', 2, -1 }
    },

    keymap = {
      'n',
      shortcut,
      action,
      mapping_opts
    }
  }

  return {
    type = 'button',
    val = options.button_char .. ' ' .. text,
    opts = opts,
    on_press = action
  }
end

local header = {
  type = 'text',
  val = options.header,
  opts = {
    position = 'center',
    hl = 'AlphaHeader'
  }
}

local footer = {
  type = 'text',
  val = options.footer,
  opts = {
    position = 'center',
    hl = 'AlphaFooter'
  }
}

local shortcuts = {
  type = 'group',
  opts = { spacing = 1 },
  val = {
    button('e', 'New file', vim.cmd.enew),
    button('f', 'Find files', with_args(builtin.find_files, { hidden = true })),
    button('r', 'Recent', builtin.oldfiles)
  }
}

local margin = { type = 'padding', val = 1 }
local header_margin = {
  type = 'padding',
  val = vim.fn.max({
    2, vim.fn.floor(vim.fn.winheight(0) * options.top_margin)
  })
}

--- @type plugin_config
return {
  opts = {
    opts = { noautocmd = true },
    layout = {
      header_margin,
      header,
      margin,
      shortcuts,
      footer
    }
  }
}
