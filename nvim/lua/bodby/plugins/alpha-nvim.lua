local header_margin = vim.fn.max({
  2, vim.fn.floor(vim.fn.winheight(0) * 0.385)
})

local header = {
  type = "text",
  val = "78 101 111 118 105 109",
  -- val = {
  --   "           ▄ ▄                   ",
  --   "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
  --   "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
  --   "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
  --   "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
  --   "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
  --   "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
  --   "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
  --   "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    "
  -- },
  -- val = {
  --   "            :h-                                  Nhy`               ",
  --   "           -mh.                           h.    `Ndho               ",
  --   "           hmh+                          oNm.   oNdhh               ",
  --   "          `Nmhd`                        /NNmd  /NNhhd               ",
  --   "          -NNhhy                      `hMNmmm`+NNdhhh               ",
  --   "          .NNmhhs              ```....`..-:/./mNdhhh+               ",
  --   "           mNNdhhh-     `.-::///+++////++//:--.`-/sd`               ",
  --   "           oNNNdhhdo..://++//++++++/+++//++///++/-.`                ",
  --   "      y.   `mNNNmhhhdy+/++++//+/////++//+++///++////-` `/oos:       ",
  --   " .    Nmy:  :NNNNmhhhhdy+/++/+++///:.....--:////+++///:.`:s+        ",
  --   " h-   dNmNmy oNNNNNdhhhhy:/+/+++/-         ---:/+++//++//.`         ",
  --   " hd+` -NNNy`./dNNNNNhhhh+-://///    -+oo:`  ::-:+////++///:`        ",
  --   " /Nmhs+oss-:++/dNNNmhho:--::///    /mmmmmo  ../-///++///////.       ",
  --   "  oNNdhhhhhhhs//osso/:---:::///    /yyyyso  ..o+-//////////:/.      ",
  --   "   /mNNNmdhhhh/://+///::://////     -:::- ..+sy+:////////::/:/.     ",
  --   "     /hNNNdhhs--:/+++////++/////.      ..-/yhhs-/////////::/::/`    ",
  --   "       .ooo+/-::::/+///////++++//-/ossyyhhhhs/:///////:::/::::/:    ",
  --   "       -///:::::::////++///+++/////:/+ooo+/::///////.::://::---+`   ",
  --   "       /////+//++++/////+////-..//////////::-:::--`.:///:---:::/:   ",
  --   "       //+++//++++++////+++///::--                 .::::-------::   ",
  --   "       :/++++///////////++++//////.                -:/:----::../-   ",
  --   "       -/++++//++///+//////////////               .::::---:::-.+`   ",
  --   "       `////////////////////////////:.            --::-----...-/    ",
  --   "        -///://////////////////////::::-..      :-:-:-..-::.`.+`    ",
  --   "         :/://///:///::://::://::::::/:::::::-:---::-.-....``/- -   ",
  --   "           ::::://::://::::::::::::::----------..-:....`.../- -+oo/ ",
  --   "            -/:::-:::::---://:-::-::::----::---.-.......`-/.      ``",
  --   "           s-`::--:::------:////----:---.-:::...-.....`./:          ",
  --   "          yMNy.`::-.--::..-dmmhhhs-..-.-.......`.....-/:`           ",
  --   "         oMNNNh. `-::--...:NNNdhhh/.--.`..``.......:/-              ",
  --   "        :dy+:`      .-::-..NNNhhd+``..`...````.-::-`                ",
  --   "                        .-:mNdhh:.......--::::-`                    ",
  --   "                           yNh/..------..`                          ",
  --   "                                                                    "
  -- },

  opts = {
    position = "center",
    hl       = "AlphaHeader"
  }
}

local footer = {
  type = "text",
  val  = "Sent from my iPhone",

  opts = {
    position = "center",
    hl       = "AlphaFooter"
  }
}

local button = function(shortcut, text, action)
  local opts = {
    position       = "center",
    shortcut       = shortcut,
    cursor         = 0,
    width          = 48,
    shrink_margin  = true,
    align_shortcut = "right",
    hl = {
      { "AlphaButtons",     0,  2 },
      { "AlphaHeaderLabel", 2, -1 }
    },
    hl_shortcut = "AlphaShortcut",
    keymap = {
      "n",
      shortcut,
      action,
      {
        noremap = true,
        silent  = true,
        nowait  = true
      }
    }
  }

  local function on_press()
    -- local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
    -- vim.api.nvim_feedkeys(keys, "t", false)
    action()
  end

  return {
    type     = "button",
    val      = "* " .. text,
    opts     = opts,
    on_press = on_press
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

    button("v", "Open vault", function()
      vim.cmd "cd ~/vault"
      require("telescope.builtin").find_files({
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
    { type = "padding", val = 1 },
    shortcuts,
    footer
  },

  opts = {
    margin    = 8,
    noautocmd = false
  }
})
