-- Vertically center logo.
local top_margin = 0.3
local header_margin = vim.fn.max({
  2, vim.fn.floor(vim.fn.winheight(0) * top_margin)
})

local header = {
  type = "text",
  opts = {
    position = "center",
    hl = "DashboardLogo"
  },
  val = {
    "           ▄ ▄                   ",
    "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
    "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
    "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
    "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
    "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
    "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
    "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
    "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    "
  }
}

local footer = {
  type = "text",
  opts = {
    position = "center",
    hl = "DashboardFooter"
  },
  val = {
    '"This quote is often falsely attributed to Mark Twain"',
    "- Mark Twain"
  }
}

local function button(shortcut, text, action)
  local opts = {
    position = "center",
    shortcut = shortcut,
    cursor = 0,
    width = 48,
    shrink_margin = true,
    align_shortcut = "right",
    hl = {
      { "DashboardButton", 0, 2 },
      { "DashboardDesc", 2, -1 }
    },
    hl_shortcut = "DashboardKey",
    keymap = {
      "n",
      shortcut,
      action,
      {
        noremap = true,
        silent = true,
        nowait = true
      }
    }
  }

  local function on_press()
    -- local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
    -- vim.api.nvim_feedkeys(keys, "t", false)
    action()
  end

  return {
    type = "button",
    val = "* " .. text,
    on_press = on_press,
    opts = opts
  }
end

local shortcuts = {
  type = "group",
  val = {
    button("e", "New file", function()
      vim.cmd "enew"
    end),
    button("f", "Find file", function()
      require("telescope.builtin").find_files({
        prompt_title = false
      })
    end),
    button("r", "Recent file", function()
      require("telescope.builtin").oldfiles({
        prompt_title = false
      })
    end),
    button("q", "Quit", function()
      vim.cmd "qa"
    end)
  },
  opts = { spacing = 1 }
}

require("alpha").setup({
  layout = {
    { type = "padding", val = header_margin },
    header,
    { type = "padding", val = 2 },
    shortcuts,
    footer
  },
  opts = {
    margin = 8,
    noautocmd = false
  }
})
