local colors = {
  gray1 = "#1e232e",
  gray2 = "#131720",
  gray3 = "#0e1119",

  white1 = "#ccddfb",
  white2 = "#9fadc6",
  white3 = "#5c6984",

  purple = "#a87dff",
  blue   = "#809fff",
  yellow = "#ffb06b",
  green  = "#bbef86",
  red    = "#f75f8d",
  cyan   = "#89bcff"
}

vim.cmd "highlight clear"
vim.cmd "syntax reset"

-- TODO: vvv
vim.g.colors_name = "bodby"

local hls = {
  ["AlphaButtons"]     = { fg = colors.cyan },
  ["AlphaHeaderLabel"] = { fg = colors.white2 },
  ["AlphaShortcut"]    = { fg = colors.purple, bold = true },
  ["AlphaHeader"]      = { fg = colors.white1, bold = true },
  ["AlphaFooter"]      = { fg = colors.white3, italic = true },

  ["BlinkCmpMenu"]              = { fg = colors.white3, bg = colors.gray3 },
  ["BlinkCmpMenuSelection"]     = { fg = colors.white1, bold = true },
  ["BlinkCmpLabelMatch"]        = { bold = true },
  ["BlinkCmpKindText"]          = { fg = colors.green },
  ["BlinkCmpKindMethod"]        = { fg = colors.blue },
  ["BlinkCmpKindFunction"]      = { fg = colors.blue },
  ["BlinkCmpKindConstructor"]   = { fg = colors.blue },
  ["BlinkCmpKindField"]         = { fg = colors.white2 },
  ["BlinkCmpKindVariable"]      = { fg = colors.white1 },
  ["BlinkCmpKindProperty"]      = { fg = colors.white2 },
  ["BlinkCmpKindClass"]         = { fg = colors.green },
  -- TODO: Interface?
  ["BlinkCmpKindInterface"]     = { fg = colors.green },
  ["BlinkCmpKindStruct"]        = { fg = colors.green },
  ["BlinkCmpKindModule"]        = { fg = colors.green },
  ["BlinkCmpKindUnit"]          = { fg = colors.green },
  ["BlinkCmpKindValue"]         = { fg = colors.green },
  -- FIXME: Enum and EnumMember should be different.
  ["BlinkCmpKindEnum"]          = { fg = colors.green },
  ["BlinkCmpKindEnumMember"]    = { fg = colors.green },
  ["BlinkCmpKindKeyword"]       = { fg = colors.purple },
  ["BlinkCmpKindConstant"]      = { fg = colors.green, bold = true },
  ["BlinkCmpKindSnippet"]       = { fg = colors.cyan },
  ["BlinkCmpKindColor"]         = { fg = colors.green },
  ["BlinkCmpKindFile"]          = { fg = colors.white1 },
  ["BlinkCmpKindReference"]     = { fg = colors.white1 },
  ["BlinkCmpKindFolder"]        = { fg = colors.white2 },
  -- TODO: vvv
  ["BlinkCmpKindEvent"]         = { fg = colors.green },
  ["BlinkCmpKindOperator"]      = { fg = colors.cyan },
  ["BlinkCmpKindTypeParameter"] = { fg = colors.white2 },

  ["RenderMarkdownCode"]       = { bg = colors.gray3 },
  ["RenderMarkdownCodeInline"] = { fg = colors.purple, bg = colors.gray3 },
  ["RenderMarkdownDash"]       = { link = "WinSeparator" },

  ["VirtColumn"]        = { fg = colors.gray1, bg = nil },
  ["IndentLine"]        = { fg = colors.gray1 },
  ["IndentLineCurrent"] = { fg = colors.gray1 },
  -- ["Hlargs"]            = { fg = colors.green, italic = true },

  ["Added"]                = { fg = colors.green },
  ["Changed"]              = { fg = colors.yellow },
  ["Removed"]              = { fg = colors.red },
  ["GitSignsDeleteVirtLn"] = { fg = colors.red },

  ["TelescopePromptNormal"]   = { bg = colors.gray3 },
  ["TelescopePromptBorder"]   = { fg = colors.gray2,  bg = colors.gray3 },
  ["TelescopePromptPrefix"]   = { fg = colors.white3 },
  ["TelescopeResultsNormal"]  = { fg = colors.white3, bg = colors.gray3 },
  ["TelescopeResultsBorder"]  = { fg = colors.gray2,  bg = colors.gray3 },
  ["TelescopePreviewNormal"]  = { fg = colors.white1, bg = colors.gray3 },
  ["TelescopePreviewBorder"]  = { fg = colors.gray2,  bg = colors.gray3 },
  ["TelescopePreviewTitle"]   = { fg = colors.gray1,  bg = colors.gray3 },
  ["TelescopePreviewMatch"]   = { bg = colors.gray2 },
  ["TelescopePreviewLine"]    = { bg = colors.gray2 },
  ["TelescopeMatching"]       = { bold = true },
  ["TelescopeSelection"]      = { fg = colors.white1, bold = true },
  ["TelescopeMultiSelection"] = { fg = colors.cyan },

  -- TODO: Proper highlights for statusline.
  ["StatusLine"]          = { fg = colors.gray1, bg = colors.gray2 },
  ["StatusLineCyan"]      = { bg = colors.cyan },
  ["StatusLinePurple"]    = { bg = colors.purple },
  ["StatusLineRed"]       = { bg = colors.red },
  ["StatusLineGreen"]     = { bg = colors.green },
  ["StatusLineYellow"]    = { bg = colors.yellow },
  ["StatusLineGray"]      = { bg = colors.white3 },
  ["StatusLineMode"]      = { fg = colors.white1, bg = colors.gray3, bold = true },
  ["StatusLinePos"]       = { fg = colors.white2, bg = colors.gray3 },
  ["StatusLineSyntax"]    = { fg = colors.white1, bg = colors.gray3 },
  ["StatusLineMacro"]     = { fg = colors.purple, bg = colors.gray3, bold = true },
  ["StatusLineFile"]      = { fg = colors.white2, bg = colors.gray3 },
  ["StatusLineFileType"]  = { fg = colors.white1, bg = colors.gray3, bold = true },
  ["StatusLineNewLine"]   = { fg = colors.white2, bg = colors.gray3 },
  ["StatusLineError"]     = { fg = colors.red,    bg = colors.gray3 },
  ["StatusLineWarn"]      = { fg = colors.yellow, bg = colors.gray3 },
  ["StatusLineMisc"]      = { fg = colors.purple, bg = colors.gray3 },
  ["StatusLineGitBranch"] = { fg = colors.white1, bg = colors.gray3, bold = true },
  ["StatusLineGitLines"]  = { fg = colors.white2, bg = colors.gray3 },

  -- ["WinBar"]     = { fg = colors.white1, bg = colors.gray3, bold = true },
  -- ["WinBarFill"] = { fg = colors.gray1,  bg = colors.gray3 },
  -- ["WinBarNC"]   = { fg = colors.white3, bg = colors.gray3 },
  -- ["WinBarLOC"]  = { fg = colors.white3, bg = colors.gray3 },
  -- ["WinBarMod"]  = { fg = colors.white1, bg = colors.gray3 },

  ["TabLine"]         = { fg = colors.white1, bg = colors.gray2 },
  ["TabLineSel"]      = { fg = colors.white1, bg = colors.gray3, bold = true },
  ["TabLineInactive"] = { fg = colors.white3, bg = colors.gray3 },
  ["TabLineIndex"]    = { fg = colors.purple, bg = colors.gray3, bold = true },
  ["TabLineIndexNC"]  = { fg = colors.white2, bg = colors.gray3 },
  ["TabLineError"]    = { fg = colors.red,    bg = colors.gray3 },
  ["TabLineWarn"]     = { fg = colors.yellow, bg = colors.gray3 },
  ["TabLineHint"]     = { fg = colors.purple, bg = colors.gray3 },
  ["TabLineInfo"]     = { fg = colors.blue,   bg = colors.gray3 },

  ["DiagnosticError"]          = { fg = colors.red },
  ["DiagnosticHint"]           = { fg = colors.purple },
  ["DiagnosticInfo"]           = { fg = colors.purple },
  ["DiagnosticOk"]             = { fg = colors.white3 },
  ["DiagnosticWarn"]           = { fg = colors.yellow },
  ["DiagnosticUnderlineError"] = { sp = colors.red,    underline = true },
  ["DiagnosticUnderlineHint"]  = { sp = colors.purple, underline = true },
  ["DiagnosticUnderlineInfo"]  = { sp = colors.blue,   underline = true },
  ["DiagnosticUnderlineOk"]    = { sp = colors.white3, underline = true },
  ["DiagnosticUnderlineWarn"]  = { sp = colors.yellow, underline = true },
  ["DiagnosticDeprecated"]     = { fg = colors.white3, strikethrough = true },

  ["Normal"]              = { fg = colors.white1, bg = colors.gray2 },
  ["NormalFloat"]         = { fg = colors.white1, bg = colors.gray2 },
  ["EndOfBuffer"]         = { fg = colors.gray1 },
  ["Debug"]               = { fg = colors.purple },
  ["Directory"]           = { fg = colors.white2 },
  ["MsgArea"]             = { bg = colors.gray3 },
  ["Error"]               = { fg = colors.purple },
  ["ErrorMsg"]            = { fg = colors.purple },
  ["Warning"]             = { fg = colors.white2 },
  ["WarningMsg"]          = { fg = colors.white2 },
  ["Exception"]           = { fg = colors.white2 },
  ["IncSearch"]           = { fg = colors.white1, bg = colors.gray1, bold = true },
  ["MatchParen"]          = { fg = colors.yellow, bold = true },
  ["Search"]              = { fg = colors.white1, bg = colors.gray1, bold = true },
  ["Substitute"]          = { fg = colors.white1, bg = colors.gray1, bold = true },
  ["Macro"]               = { fg = colors.blue },
  ["ModeMsg"]             = { fg = colors.white2 },
  ["MoreMsg"]             = { fg = colors.white1 },
  ["SpellBad"]            = { fg = colors.yellow },
  ["SpellRare"]           = { fg = colors.blue },
  ["SpellCap"]            = { fg = colors.blue },
  ["Question"]            = { fg = colors.white2 },
  ["SpecialKey"]          = { fg = colors.purple },
  ["Visual"]              = { bg = colors.gray1 },
  ["Title"]               = { fg = colors.white1, bold = true },
  ["Conceal"]             = { fg = colors.white3 },
  ["Cursor"]              = { fg = colors.gray3, bg = colors.cyan },
  ["LineNr"]              = { fg = colors.white3 },
  ["LineNrSpecial"]       = { fg = colors.white2, bold = true },
  ["LineNrWrapped"]       = { fg = colors.gray1 },
  ["WinSeparator"]        = { fg = colors.gray3 },
  ["ColorColumn"]         = { fg = colors.gray1, bg = nil },
  ["SignColumn"]          = { fg = colors.gray1 },
  ["CursorLine"]          = { bg = colors.gray3 },
  ["CursorLineNr"]        = { fg = colors.white1, bg = nil, bold = true },
  ["CursorLineSign"]      = { bg = nil },
  ["CursorLineNrWrapped"] = { fg = colors.gray1,  bg = nil },
  ["Pmenu"]               = { fg = colors.white3, bg = colors.gray2 },
  ["PmenuSbar"]           = { bg = colors.gray2 },
  ["PmenuThumb"]          = { bg = colors.gray1 },
  ["PmenuSel"]            = { fg = colors.white1, bold = true },
  ["NonText"]             = { fg = colors.white3 },

  ["Boolean"]     = { fg = colors.green },
  ["Character"]   = { fg = colors.green },
  ["Comment"]     = { fg = colors.white3, italic = true },
  ["Conditional"] = { fg = colors.cyan },
  ["Constant"]    = { fg = colors.yellow },
  ["Delimiter"]   = { fg = colors.cyan },
  ["Float"]       = { fg = colors.green },
  ["Function"]    = { fg = colors.blue },
  ["Identifier"]  = { fg = colors.white2 },
  ["Keyword"]     = { fg = colors.cyan },
  ["Label"]       = { fg = colors.green },
  ["PreProc"]     = { fg = colors.purple },
  ["Number"]      = { fg = colors.green },
  ["Operator"]    = { fg = colors.cyan },
  ["Special"]     = { fg = colors.white1 },
  ["SpecialChar"] = { fg = colors.green },
  ["Statement"]   = { fg = colors.white2 },
  ["String"]      = { fg = colors.green },
  ["Tag"]         = { fg = colors.blue },
  ["Todo"]        = { fg = colors.green },
  ["Type"]        = { fg = colors.purple },

  ["@comment.warning"] = { fg = colors.white1, bold = true },
  ["@comment.error"]   = { fg = colors.white1, bold = true },
  ["@comment.todo"]    = { fg = colors.white1, bold = true },
  ["@comment.note"]    = { fg = colors.white1, bold = true },

  ["@type.builtin"]        = { link = "Type" },
  ["@number"]              = { link = "Number" },
  ["@property"]            = { fg = colors.white2 },
  ["@variable.member"]     = { fg = colors.white2 },
  ["@variable.parameter"]  = { fg = colors.white1 },
  ["@function.builtin"]    = { link = "Function" },
  ["@variable"]            = { fg = colors.white1 },
  ["@keyword.conditional"] = { link = "Conditional" },
  -- ["@keyword.function"]    = { fg = colors.purple },
  ["@punctuation.special"] = { link = "Operator" },
  ["@character.special"]   = { fg = colors.cyan },
  ["@constant.builtin"]    = { fg = colors.green },
  ["@constructor"]         = { fg = colors.yellow },
  ["@namespace"]           = { fg = colors.yellow },
  ["@module"]              = { fg = colors.yellow },
  ["@module.builtin"]      = { fg = colors.yellow },

  ["@function.macro.vim"] = { link = "String" },
  ["@constructor.lua"]    = { link = "@punctuation.bracket" },

  ["@keyword.import.nix"] = { link = "@function.call" },

  ["@tag.delimiter.html"] = { link = "Delimiter" },
  ["@tag.attribute.html"] = { fg = colors.purple },

  ["@constructor.ocaml"] = { link = "@punctuation.bracket" },

  ["@spell.markdown"] = { fg = colors.white2 },
  ["@markup.heading"] = { link = "Title" },
  ["@markup.link"]    = { fg = colors.white1 },
  ["@markup.strong"]  = { fg = colors.white1, bold = true },

  ["@lsp.type.macro"] = { }
}

for hl, opts in pairs(hls) do
  vim.api.nvim_set_hl(0, hl, opts)
end

vim.g.terminal_color_0  = colors.gray3
vim.g.terminal_color_1  = colors.red
vim.g.terminal_color_2  = colors.green
vim.g.terminal_color_3  = colors.yellow
vim.g.terminal_color_4  = colors.blue
vim.g.terminal_color_5  = colors.purple
vim.g.terminal_color_6  = colors.cyan
vim.g.terminal_color_7  = colors.white2
vim.g.terminal_color_8  = colors.gray1
vim.g.terminal_color_9  = colors.red
vim.g.terminal_color_10 = colors.green
vim.g.terminal_color_11 = colors.yellow
vim.g.terminal_color_12 = colors.blue
vim.g.terminal_color_13 = colors.purple
vim.g.terminal_color_14 = colors.cyan
vim.g.terminal_color_15 = colors.white1
