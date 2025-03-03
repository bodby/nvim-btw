local colors = {
  gray1 = "#1d232f",
  gray2 = "#131720",
  gray3 = "#0e1119",

  white1 = "#c2d5ff",
  white2 = "#95a6c6",
  white3 = "#4e596f",

  purple = "#9d7dff",
  blue = "#809cff",
  yellow = "#ffb96b",
  green = "#bbef86",
  red = "#f75fa8",
  cyan = "#89bcff",
}

vim.cmd("highlight clear")
vim.cmd("syntax reset")

vim.g.colors_name = "bodby"

-- TODO: Generate statusline and tabline diagnostic highlights using the normal "Error",
--       "Warning", etc. highlights.

-- For creating "BG" and "FG" variants.
local stl_hls = {
  ["StatusLineNormal"] = colors.cyan,
  ["StatusLineVisual"] = colors.green,
  ["StatusLineSelect"] = colors.green,
  ["StatusLineInsert"] = colors.purple,
  ["StatusLineReplace"] = colors.red,
  ["StatusLineCommand"] = colors.yellow,
  ["StatusLinePrompt"] = colors.white3,
  ["StatusLineShell"] = colors.white3,
  ["StatusLineLimbo"] = colors.white3,
}

-- For creating "Entryand "EntryNC" variants.
local tabl_hls = {
  ["Error"] = colors.red,
  ["Warn"]  = colors.yellow,
  ["Info"]  = colors.blue,
  ["Hint"]  = colors.purple,
}

local hls = {
  ["AlphaButtons"]     = { fg = colors.cyan },
  ["AlphaHeaderLabel"] = { fg = colors.white2 },
  ["AlphaShortcut"]    = { fg = colors.purple, bold = true },
  ["AlphaHeader"]      = { fg = colors.white1, bold = true },
  ["AlphaFooter"]      = { fg = colors.white3, italic = true },

  ["BlinkCmpMenu"]              = { fg = colors.white3, bg = colors.gray3 },
  ["BlinkCmpMenuSelection"]     = { fg = colors.white1, bold = true },
  ["BlinkCmpLabelMatch"]        = { bold = true },
  ["BlinkCmpLabelDeprecated"]   = { strikethrough = true },
  ["BlinkCmpKindText"]          = { fg = colors.white2 },
  ["BlinkCmpKindMethod"]        = { fg = colors.blue },
  ["BlinkCmpKindFunction"]      = { fg = colors.blue },
  ["BlinkCmpKindConstructor"]   = { fg = colors.yellow },
  ["BlinkCmpKindField"]         = { fg = colors.white2 },
  ["BlinkCmpKindVariable"]      = { fg = colors.white1 },
  ["BlinkCmpKindProperty"]      = { fg = colors.white2 },
  ["BlinkCmpKindClass"]         = { fg = colors.purple },
  -- TODO: Are these typeclasses/traits?
  ["BlinkCmpKindInterface"]     = { fg = colors.purple },
  ["BlinkCmpKindStruct"]        = { fg = colors.purple },
  ["BlinkCmpKindModule"]        = { fg = colors.yellow },
  ["BlinkCmpKindUnit"]          = { fg = colors.green },
  ["BlinkCmpKindValue"]         = { fg = colors.green },
  ["BlinkCmpKindEnum"]          = { fg = colors.purple },
  ["BlinkCmpKindEnumMember"]    = { fg = colors.yellow },
  ["BlinkCmpKindKeyword"]       = { fg = colors.cyan,   bold = true },
  ["BlinkCmpKindConstant"]      = { fg = colors.white1, bold = true },
  ["BlinkCmpKindSnippet"]       = { fg = colors.purple, bold = true },
  ["BlinkCmpKindColor"]         = { fg = colors.green },
  ["BlinkCmpKindFile"]          = { fg = colors.white1 },
  ["BlinkCmpKindReference"]     = { fg = colors.white1 },
  ["BlinkCmpKindFolder"]        = { fg = colors.white2 },
  ["BlinkCmpKindEvent"]         = { fg = colors.green },
  ["BlinkCmpKindOperator"]      = { fg = colors.cyan },
  ["BlinkCmpKindTypeParameter"] = { fg = colors.white2 },

  ["RenderMarkdownCode"]       = { bg = colors.gray3 },
  ["RenderMarkdownCodeInline"] = { fg = colors.purple, bg = colors.gray3 },
  ["RenderMarkdownDash"]       = { fg = colors.gray1 },

  ["VirtColumn"] = { fg = colors.gray1 },
  -- ["IndentLine"]        = { fg = colors.gray1 },
  -- ["IndentLineCurrent"] = { fg = colors.white3 },
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
  ["TelescopePreviewNormal"]  = { fg = colors.white2, bg = colors.gray3 },
  ["TelescopePreviewBorder"]  = { fg = colors.gray2,  bg = colors.gray3 },
  ["TelescopePreviewTitle"]   = { fg = colors.gray1,  bg = colors.gray3 },
  ["TelescopePreviewMatch"]   = { bg = colors.gray2 },
  ["TelescopePreviewLine"]    = { bg = colors.gray2 },
  ["TelescopeMatching"]       = { bold = true },
  ["TelescopeSelection"]      = { fg = colors.white1, bold = true },
  ["TelescopeMultiSelection"] = { fg = colors.cyan },

  ["StatusLine"]          = { fg = colors.gray1,  bg = colors.gray3 },
  ["StatusLineDirectory"] = { fg = colors.white3, bg = colors.gray3 },
  ["StatusLineFile"]      = { fg = colors.white2, bg = colors.gray3 },
  ["StatusLineBranch"]    = { fg = colors.white1, bg = colors.gray3, bold = true },
  ["StatusLineDelta"]     = { fg = colors.white2, bg = colors.gray3 },
  ["StatusLineMacro"]     = { fg = colors.purple, bg = colors.gray3, bold = true },
  ["StatusLineError"]     = { fg = colors.red,    bg = colors.gray3, bold = true },
  ["StatusLineWarn"]      = { fg = colors.yellow, bg = colors.gray3, bold = true },
  ["StatusLineInfo"]      = { fg = colors.blue,   bg = colors.gray3, bold = true },
  ["StatusLineHint"]      = { fg = colors.purple, bg = colors.gray3, bold = true },
  ["StatusLineFileType"]  = { fg = colors.white1, bg = colors.gray3, bold = true },
  ["StatusLineNewLine"]   = { fg = colors.white2, bg = colors.gray3 },
  ["StatusLinePos"]       = { fg = colors.white1, bg = colors.gray3, bold = true },
  ["StatusLinePercent"]   = { fg = colors.white2, bg = colors.gray3 },

  -- ["WinBar"]     = { fg = colors.white1, bg = colors.gray3, bold = true },
  -- ["WinBarFill"] = { fg = colors.gray1,  bg = colors.gray3 },
  -- ["WinBarNC"]   = { fg = colors.white3, bg = colors.gray3 },
  -- ["WinBarLOC"]  = { fg = colors.white3, bg = colors.gray3 },
  -- ["WinBarMod"]  = { fg = colors.white1, bg = colors.gray3 },

  ["TabLine"] = { fg = colors.white1, bg = colors.gray2 },
  ["TabLineEntry"] = {
    fg        = colors.white1,
    bg        = colors.gray2,
    sp        = colors.cyan,
    bold      = true,
    underline = true,
  },
  ["TabLineEntryNC"]   = { fg = colors.white3, bg = colors.gray2 },
  ["TabLineIndex"]     = { fg = colors.cyan,   bg = colors.gray2, bold = true },
  ["TabLineLineCount"] = { fg = colors.white3, bg = colors.gray2 },
  ["TabLineCount"] = {
    fg        = colors.cyan,
    bg        = colors.gray2,
    sp        = colors.cyan,
    bold      = true,
    underline = true,
  },
  ["TabLineCountNC"]   = { fg = colors.white2, bg = colors.gray2 },

  ["Folded"]     = { fg = colors.white2, bg = colors.gray1 },
  ["FoldedDeco"] = { fg = colors.cyan, bg = colors.gray1 },

  ["DiagnosticError"]          = { fg = colors.red, bold = true },
  ["DiagnosticInfo"]           = { fg = colors.blue, bold = true },
  ["DiagnosticHint"]           = { fg = colors.purple, bold = true },
  ["DiagnosticOk"]             = { fg = colors.white3, bold = true },
  ["DiagnosticWarn"]           = { fg = colors.yellow, bold = true },
  ["DiagnosticUnderlineError"] = { sp = colors.red,    underline = true },
  ["DiagnosticUnderlineHint"]  = { sp = colors.purple, underline = true },
  ["DiagnosticUnderlineInfo"]  = { sp = colors.blue,   underline = true },
  ["DiagnosticUnderlineOk"]    = { sp = colors.white3, underline = true },
  ["DiagnosticUnderlineWarn"]  = { sp = colors.yellow, underline = true },
  ["DiagnosticDeprecated"]     = { fg = colors.white3, strikethrough = true },
  ["DiagnosticUnnecessary"]    = { fg = colors.white3, italic = true },

  ["Normal"]              = { fg = colors.white2, bg = colors.gray2 },
  ["NormalFloat"]         = { fg = colors.white2, bg = colors.gray3 },
  ["EndOfBuffer"]         = { fg = colors.gray1 },
  ["Debug"]               = { fg = colors.purple },
  ["Directory"]           = { fg = colors.white2 },
  ["MsgArea"]             = { bg = colors.gray3 },
  ["Error"]               = { fg = colors.red },
  ["ErrorMsg"]            = { fg = colors.red },
  ["Warning"]             = { fg = colors.yellow },
  ["WarningMsg"]          = { fg = colors.yellow },
  -- TODO: vvv
  ["Exception"]           = { fg = colors.purple },
  ["IncSearch"]           = { fg = colors.white1, bg = colors.gray1, bold = true },
  ["MatchParen"]          = { fg = colors.yellow, bold = true },
  ["Search"]              = { fg = colors.white1, bg = colors.gray1, bold = true },
  ["Substitute"]          = { fg = colors.white1, bg = colors.gray1, bold = true },
  ["Macro"]               = { fg = colors.blue },
  ["ModeMsg"]             = { fg = colors.white2 },
  ["MoreMsg"]             = { fg = colors.white1 },
  ["SpellBad"]            = { sp = colors.yellow, undercurl = true },
  ["SpellRare"]           = { sp = colors.blue, undercurl = true },
  ["SpellCap"]            = { sp = colors.blue, undercurl = true },
  ["Question"]            = { fg = colors.white2 },
  ["SpecialKey"]          = { fg = colors.purple },
  ["Visual"]              = { bg = colors.gray1 },
  ["SnippetTabstop"]      = { italic = true },
  ["Title"]               = { fg = colors.white1, bold = true },
  ["Conceal"]             = { fg = colors.white3 },
  ["Cursor"]              = { fg = colors.gray3, bg = colors.cyan },
  ["LineNr"]              = { fg = colors.white3 },
  ["LineNrSpecial"]       = { fg = colors.white2, bold = true },
  ["LineNrWrapped"]       = { fg = colors.white3 },
  ["WinSeparator"]        = { fg = colors.gray2 },
  ["ColorColumn"]         = { fg = colors.gray1 },
  ["SignColumn"]          = { fg = colors.gray1 },
  ["CursorLine"]          = { },
  ["CursorLineNr"]        = { fg = colors.white1, bold = true },
  ["CursorLineSign"]      = { bg = nil },
  ["CursorLineNrWrapped"] = { fg = colors.white3, bg = nil },
  ["Pmenu"]               = { fg = colors.white3, bg = colors.gray2 },
  ["PmenuSbar"]           = { bg = colors.gray2 },
  ["PmenuThumb"]          = { bg = colors.gray1 },
  ["PmenuSel"]            = { fg = colors.white1, bold = true },
  ["NonText"]             = { fg = colors.white3 },

  ["Boolean"]     = { fg = colors.green },
  ["Character"]   = { fg = colors.green },
  ["Comment"]     = { fg = colors.white3, italic = true },
  ["Conditional"] = { fg = colors.purple, bold = true },
  ["Constant"]    = { fg = colors.yellow, bold = true },
  ["Delimiter"]   = { fg = colors.cyan, nocombine = true },
  ["Float"]       = { fg = colors.green },
  ["Function"]    = { fg = colors.blue },
  ["Identifier"]  = { fg = colors.white2 },
  ["Keyword"]     = { fg = colors.cyan, bold = true },
  ["Label"]       = { fg = colors.purple, bold = true },
  ["PreProc"]     = { fg = colors.purple },
  ["Number"]      = { fg = colors.green },
  ["Operator"]    = { fg = colors.cyan },
  ["Special"]     = { fg = colors.purple },
  ["SpecialChar"] = { fg = colors.green, italic = true },
  ["Statement"]   = { fg = colors.white2 },
  ["String"]      = { fg = colors.green },
  ["Tag"]         = { fg = colors.blue },
  ["Todo"]        = { fg = colors.white2, bold = true },
  ["Type"]        = { fg = colors.purple },

  ["@comment.warning"] = { fg = colors.cyan, bold = true },
  ["@comment.error"]   = { fg = colors.cyan, bold = true },
  ["@comment.todo"]    = { fg = colors.cyan, bold = true },
  ["@comment.note"]    = { fg = colors.cyan, bold = true },

  -- Users, e.g.
  -- TODO (@bodby): Something.
  ["@constant.comment"] = { fg = colors.blue },

  ["@type.builtin"]        = { link = "Type" },
  ["@number"]              = { link = "Number" },
  ["@property"]            = { fg = colors.white2 },
  ["@variable.member"]     = { fg = colors.white2 },
  ["@variable.parameter"]  = { fg = colors.white1 },
  ["@function.builtin"]    = { link = "Function" },
  ["@variable"]            = { fg = colors.white1 },
  ["@keyword.conditional"] = { link = "Conditional" },
  ["@keyword.function"]    = { fg = colors.purple, bold = true },
  ["@keyword.operator"]    = { fg = colors.cyan },
  ["@punctuation.special"] = { link = "Operator" },
  ["@character.special"]   = { fg = colors.cyan },
  -- TODO: Does this only affect 'null' and 'nil'?
  ["@constant.builtin"]    = { link = "Boolean" },
  ["@constructor"]         = { fg = colors.yellow },
  ["@namespace"]           = { fg = colors.yellow, bold = true },
  ["@module"]              = { fg = colors.yellow, bold = true },
  ["@module.builtin"]      = { fg = colors.yellow, bold = true },

  ["@function.macro.vim"] = { link = "String" },
  ["@constructor.lua"]    = { link = "@punctuation.bracket" },

  ["@keyword.import.nix"]             = { link = "@function.call" },
  ["@variable.parameter.builtin.nix"] = { link = "Delimiter" },

  ["@tag.delimiter.html"] = { link = "Delimiter" },
  ["@tag.attribute.html"] = { fg = colors.purple },

  ["@constructor.ocaml"] = { link = "@punctuation.bracket" },

  ["@markup.heading"] = { link = "Title" },
  ["@markup.link"]    = { fg = colors.white1 },
  ["@markup.strong"]  = { fg = colors.white1, bold = true },

  ["@module.latex"]                 = { link = "Keyword" },
  ["@markup.link.latex"]            = { fg = colors.white1 },
  ["@string.special.symbol.bibtex"] = { fg = colors.white1 },

  ["@punctuation.special.luadoc"] = { fg = colors.purple },

  ["@lsp.type.macro"]    = { },
  -- ["@lsp.type.variable"] = { },
  ["@lsp.mod.global"]    = { link = "@module" },
  ["@lsp.type.comment"]  = { },
}

for hl, opts in pairs(hls) do
  vim.api.nvim_set_hl(0, hl, opts)
end

for hl, col in pairs(stl_hls) do
  vim.api.nvim_set_hl(0, hl .. "BG", { bg = col })
  vim.api.nvim_set_hl(0, hl .. "FG", { fg = col, bg = colors.gray3, bold = true })
end

for hl, col in pairs(tabl_hls) do
  vim.api.nvim_set_hl(0, "TabLine" .. hl,      { fg = col, bg = colors.gray2, bold = true })
  vim.api.nvim_set_hl(0, "TabLineEntry" .. hl, {
    fg        = col,
    bg        = colors.gray2,
    sp        = colors.cyan,
    bold      = true,
    underline = true,
  })
  vim.api.nvim_set_hl(0, "TabLineEntry" .. hl .. "NC", { fg = col, bg = colors.gray2 })
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
