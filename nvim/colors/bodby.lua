--- @class (exact) Highlights
--- @field prefix? string
--- @field base? Base
--- @field highlights table<string, table>

--- @type table<string, string>
local colors = {
  white1 = '#aec5f2',
  white2 = '#91a4ca',
  white3 = '#495674',
  gray1 = '#1d232f',
  gray2 = '#131720',
  gray3 = '#0e1119',
  purple = '#9d7dff',
  blue = '#809cff',
  yellow = '#ffc175',
  green = '#bbf48a',
  red = '#f75fa8',
  cyan = '#89bcff',
}

--- Atomic highlights that others can inherit from.
---
--- @enum Base
local base = {
  -- Syntax.
  identifier = { fg = colors.white1 },
  parameter = { fg = colors.white1, italic = true },
  field = { fg = colors.white2 },
  property = { fg = colors.white2 },
  keyword = { fg = colors.cyan, italic = true },
  preprocessor = { fg = colors.cyan, italic = true },
  conditional = { fg = colors.purple, italic = true },
  function_keyword = { fg = colors.purple },
  _function = { fg = colors.blue },
  operator = { fg = colors.cyan },
  delimiter = { fg = colors.cyan },
  boolean = { fg = colors.purple },
  character = { fg = colors.green },
  --- Nix paths and escape codes.
  special_char = { fg = colors.cyan, italic = true },
  number = { fg = colors.yellow },
  _string = { fg = colors.green, italic = true },
  type = { fg = colors.purple },
  constructor = { fg = colors.yellow },
  tag = { fg = colors.blue },
  module = { fg = colors.yellow, italic = true },
  constant = { fg = colors.white1, bold = true },
  builtin = { fg = colors.yellow, italic = true },
  special = { fg = colors.purple },
  comment = { fg = colors.white3, italic = true },
  -- UI.
  normal = { fg = colors.white2, bg = colors.gray2 },
  popup = { fg = colors.white2, bg = colors.gray3 },
  hover = { fg = colors.white1, bold = true },
  ghost = { fg = colors.white3, italic = true },
  folded = { fg = colors.white3, bg = colors.gray2 },
  folded_range = { fg = colors.white3 },
  cursor_line = { },
  line_number = { fg = colors.white3 },
  current_line_number = { fg = colors.cyan, bold = true },
  accent = { fg = colors.cyan, bold = true },
  caret = { fg = colors.cyan },
  cursor = { bg = colors.cyan },
  visual = { bg = colors.gray1 },
  snippet_tabstop = { italic = true },
  --- For blink.cmp and Telescope.
  matching_char = { bold = true },
  matching_search = {
    bg = colors.gray1,
    bold = true
  },
  matching_punctuation = { fg = colors.yellow, bold = true },
  key = { fg = colors.purple, bold = true },
  directory = { fg = colors.white2 },
  code = { fg = colors.cyan, bg = colors.gray3 },
  separator = { fg = colors.gray1 },
  url = {
    fg = colors.white1,
    underline = true
  },
  spell_bad = { sp = colors.red, undercurl = true },
  spell_rare = { sp = colors.purple, undercurl = true },
  spell_casing = { sp = colors.blue, undercurl = true },
  title_number = { fg = colors.white3 },
  title = {
    fg = colors.white1,
    bold = true,
    italic = true
  },
  statusline = { bg = colors.gray3 },
  statusline_cwd = { fg = colors.cyan },
  statusline_prefix = { fg = colors.white1, bold = true, italic = true },
  statusline_path = { fg = colors.white2 },
  statusline_branch = { fg = colors.white1, bold = true },
  statusline_diff = { fg = colors.white3 },
  statusline_lines = { fg = colors.white3 },
  statusline_filetype = {
    fg = colors.white2,
    italic = true
  },
  tabline = { bg = colors.gray2 },
  tab_inactive = { fg = colors.white3 },
  tab = {
    fg = colors.cyan,
    bg = colors.gray1,
    bold = true,
    underline = true
  },
  buffer_inactive = { fg = colors.white3 },
  buffer = {
    fg = colors.white1,
    sp = colors.cyan,
    bold = true,
    italic = true,
    underline = true
  },
  -- Diagnostics.
  error = { fg = colors.red },
  warn = { fg = colors.yellow },
  info = { fg = colors.blue },
  hint = { fg = colors.purple },
  success = { fg = colors.green },
  diff_added = { fg = colors.green },
  diff_changed = { fg = colors.yellow },
  diff_removed = { fg = colors.red },
  deprecated = { fg = colors.white3, strikethrough = true },
  unnecessary = { sp = colors.white3, underline = true },
  -- Todo comments.
  todo = { fg = colors.cyan },
  assignee = { fg = colors.blue },
}

--- Override a `base` highlight, returning a table usable in highlights.
---
--- @generic T
--- @param orig Base
--- @param opts table<string, T>
--- @return table<string, T>
local function inherit(orig, opts)
  return vim.tbl_deep_extend('force', orig, opts)
end

--- Shorter highlight function.
---
--- @param name string
--- @param opts table<string, any>
local function hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

--- Normal/uncategorized highlights.
---
--- @type Highlights
local highlights = {
  prefix = nil,
  highlights = {
    ['Normal'] = base.normal,
    ['StatusLine'] = base.statusline,
    ['TabLine'] = base.tabline,
    ['NormalFloat'] = base.popup,
    ['FloatBorder'] = inherit(base.popup, { fg = base.popup.bg }),
    ['Folded'] = base.folded,
    ['FoldedRange'] = base.folded_range,
    ['MsgArea'] = base.popup,
    ['Title'] = base.title,
    ['Pmenu'] = inherit(base.popup, { fg = colors.white3 }),
    ['PmenuSel'] = base.hover,
    ['Cursor'] = base.cursor,
    ['CursorLine'] = base.cursor_line,
    ['CursorLineNr'] = base.current_line_number,
    ['LineNr'] = base.line_number,
    ['CursorLineNrWrapped'] = base.current_line_number,
    ['LineNrWrapped'] = base.line_number,
    ['LineNrVirt'] = base.line_number,
    ['WinSeparator'] = base.separator,
    ['Visual'] = base.visual,
    ['Search'] = base.matching_search,
    ['IncSearch'] = { link = 'Search' },
    ['CurSearch'] = { link = 'Search' },
    ['Substitute'] = { link = 'Search' },
    ['MatchParen'] = base.matching_punctuation,
    ['NonText'] = base.ghost,
    ['Conceal'] = { link = 'NonText' },
    ['SnippetTabstop'] = base.snippet_tabstop,
    ['Keyword'] = base.keyword,
    ['PreProc'] = base.preprocessor,
    ['Typedef'] = base.keyword,
    ['StorageClass'] = base.keyword,
    ['Label'] = base.keyword,
    ['Repeat'] = base.keyword,
    ['Exception'] = base.keyword,
    ['Conditional'] = base.conditional,
    ['Identifier'] = base.identifier,
    ['Statement'] = { },
    ['String'] = base._string,
    ['Character'] = base.character,
    ['Special'] = base.special,
    ['SpecialKey'] = base.key,
    ['QuickFixLine'] = base.accent,
    ['SpecialChar'] = base.special_char,
    ['Number'] = base.number,
    ['Float'] = { link = 'Number' },
    ['Boolean'] = base.boolean,
    ['Constant'] = base.constant,
    ['Operator'] = base.operator,
    ['Delimiter'] = base.delimiter,
    ['Type'] = base.type,
    ['Function'] = base._function,
    ['Tag'] = { link = 'Function' },
    ['Macro'] = { link = 'Function' },
    ['Comment'] = base.comment,
    ['Underlined'] = base.url,
    ['Directory'] = base.directory,
    ['Todo'] = base.todo,
    ['Added'] = base.diff_added,
    ['Changed'] = base.diff_changed,
    ['Removed'] = base.diff_removed,
    ['DiffAdd'] = { link = 'Added' },
    ['DiffChange'] = { link = 'Changed' },
    ['DiffDelete'] = { link = 'Removed' },
    -- Diagnostics.
    ['Error'] = base.error,
    ['Warning'] = base.warn,
    ['ErrorMsg'] = { link = 'Error' },
    ['WarningMsg'] = { link = 'Warning' },
    ['MoreMsg'] = { link = 'Question' },
    ['Question'] = base.popup,
    ['DiagnosticUnnecessary'] = base.unnecessary,
    ['DiagnosticDeprecated'] = base.deprecated,
    ['DiagnosticError'] = base.error,
    ['DiagnosticInfo'] = base.info,
    ['DiagnosticHint'] = base.hint,
    ['DiagnosticOk'] = base.success,
    ['DiagnosticWarn'] = base.warn,
    ['DiagnosticUnderlineError'] = { sp = base.error.fg, underline = true },
    ['DiagnosticUnderlineInfo'] = { sp = base.info.fg, underline = true },
    ['DiagnosticUnderlineHint'] = { sp = base.hint.fg, underline = true },
    ['DiagnosticUnderlineOk'] = { sp = base.success.fg, underline = true },
    ['DiagnosticUnderlineWarn'] = { sp = base.warn.fg, underline = true },
    ['SpellBad'] = base.spell_bad,
    ['SpellRare'] = base.spell_rare,
    ['SpellCap'] = base.spell_casing,
  },
}

--- @type Highlights
local treesitter_highlights = {
  prefix = '@',
  highlights = {
    ['variable'] = { link = 'Identifier' },
    ['variable.parameter'] = base.parameter,
    ['property'] = base.property,
    ['variable.member'] = base.field,
    ['constructor'] = base.constructor,
    ['keyword.function'] = base.function_keyword,
    ['keyword.conditional'] = { link = 'Conditional' },
    ['keyword.operator'] = { link = 'Operator' },
    ['punctuation.special'] = { link = 'Delimiter' },
    ['tag.delimiter'] = { link = 'Delimiter' },
    ['character.special'] = { link = 'Operator' },
    ['constant.builtin'] = base.builtin,
    ['variable.builtin'] = { link = 'Constant' },
    ['function.builtin'] = { link = '@function' },
    ['type.builtin'] = { link = 'Type' },
    ['module'] = base.module,
    ['module.builtin'] = { link = '@module' },
    ['namespace'] = { link = '@module' },
    ['constructor.lua'] = { link = 'Delimiter' },
    ['variable.builtin.luadoc'] = { link = '@variable.parameter.builtin' },
    ['constructor.ocaml'] = { link = 'Delimiter' },
    ['tag.attribute.html'] = { link = '@property' },
    ['punctuation.special.bash'] = inherit(base.delimiter, { nocombine = true }),
    ['markup.raw.markdown_inline'] = base.code,
    ['markup.quote.markdown'] = { },
    ['markup.raw.block.markdown'] = base.delimiter,
    ['markup.list'] = inherit(base.comment, { italic = false }),
    -- TODO: Resolved and unresolved link colors.
    --       The unresolved highlight comes from '@lsp'.
    ['markup.link'] = base.url,
    ['markup.strong'] = { fg = colors.white1, bold = true },
    ['module.latex'] = { link = 'Keyword' },
    ['punctuation.bracket.latex'] = inherit(base.delimiter, { nocombine = true }),
    ['string.special.symbol.bibtex'] = { link = 'Identifier' },
    ['string.special.path'] = { link = 'String' },
    ['variable.parameter.builtin'] = { link = 'Delimiter' },
    ['keyword.import.nix'] = { link = 'Function' },
    -- Todo comments.
    ['comment.warning'] = { link = 'Todo' },
    ['comment.error'] = { link = 'Todo' },
    ['comment.todo'] = { link = 'Todo' },
    ['comment.note'] = { link = 'Todo' },
    ['constant.comment'] = base.assignee,
    -- LSP highlights.
    ['lsp.type.comment'] = { },
    ['lsp.type.macro'] = { },
    ['lsp.mod.global'] = { link = '@module' },
    ['lsp.type.keyword'] = { },
  }
}

--- @type Highlights
local alpha_highlights = {
  prefix = 'Alpha',
  highlights = {
    ['Buttons'] = base.caret,
    ['HeaderLabel'] = { fg = colors.white2 },
    ['Shortcut'] = base.key,
    ['Header'] = { fg = colors.white3 },
    ['Footer'] = { link = 'Comment' },
  },
}

--- @type Highlights
local blink_highlights = {
  prefix = 'BlinkCmp',
  highlights = {
    ['Menu'] = { link = 'Pmenu' },
    ['MenuSelection'] = { link = 'PmenuSel' },
    ['Source'] = { link = 'NormalFloat' },
    ['LabelMatch'] = base.matching_char,
    ['Deprecated'] = { link = 'DiagnosticDeprecated' },
    -- Types.
    ['KindText'] = { link = 'NormalFloat' },
    ['KindMethod'] = { link = 'Function' },
    ['KindFunction'] = { link = 'Function' },
    ['KindConstructor'] = { link = '@constructor' },
    ['KindField'] = { link = '@variable.member' },
    ['KindVariable'] = { link = 'Identifier' },
    ['KindProperty'] = { link = '@property' },
    ['KindClass'] = { link = 'Type' },
    ['KindInterface'] = { link = 'Type' },
    ['KindStruct'] = { link = 'Structure' },
    ['KindModule'] = { link = '@module' },
    ['KindUnit'] = { link = 'String' },
    ['KindValue'] = { link = 'Number' },
    ['KindEnum'] = { link = 'Type' },
    ['KindEnumMember'] = { link = 'Constant' },
    ['KindKeyword'] = { link = 'Keyword' },
    ['KindConstant'] = { link = 'Constant' },
    ['KindSnippet'] = base.key,
    ['KindColor'] = { link = 'String' },
    ['KindFile'] = { link = 'SpecialChar' },
    ['KindReference'] = { link = 'Identifier' },
    ['KindFolder'] = { link = 'Directory' },
    ['KindEvent'] = { link = 'Type' },
    ['KindOperator'] = { link = 'Operator' },
    ['KindTypeParameter'] = { link = 'Identifier' },
  },
}

--- @type Highlights
local telescope_highlights = {
  prefix = 'Telescope',
  highlights = {
    ['PromptNormal'] = { link = 'NormalFloat' },
    ['PromptBorder'] = { link = 'FloatBorder' },
    ['ResultsNormal'] = { link = 'Pmenu' },
    ['ResultsBorder'] = { link = 'FloatBorder' },
    ['PreviewNormal'] = { link = 'NormalFloat' },
    ['PreviewBorder'] = { link = 'FloatBorder' },
    ['Matching'] = base.matching_char,
    ['Selection'] = { link = 'PmenuSel' },
    ['SelectionCaret'] = base.caret,
    ['MultiSelection'] = { link = 'NormalFloat' },
    ['MultiIcon'] = base.accent,
    -- Symbols.
    ['ResultsMethod'] = { link = 'Function' },
    ['ResultsFunction'] = { link = 'Function' },
    ['ResultsField'] = { link = '@variable.member' },
    ['ResultsVariable'] = { link = 'Identifier' },
    ['ResultsIdentifier'] = { link = 'Identifier' },
    ['ResultsClass'] = { link = 'Type' },
    ['ResultsStruct'] = { link = 'Structure' },
    ['ResultsNumber'] = { link = 'Number' },
    ['ResultsConstant'] = { link = 'Constant' },
    ['ResultsComment'] = { link = 'Comment' },
    ['ResultsOperator'] = { link = 'Operator' },
  },
}

--- @type Highlights
local render_md_highlights = {
  prefix = 'RenderMarkdown',
  highlights = {
    ['Header'] = base.title_number,
    ['Code'] = { bg = base.code.bg },
    ['CodeInline'] = base.code,
    ['Dash'] = { link = 'WinSeparator' },
    ['TableHead'] = { link = 'WinSeparator' },
    ['TableRow'] = { link = 'WinSeparator' },
  },
}

--- @type Highlights
local statusline_highlights = {
  prefix = 'StatusLine',
  base = base.statusline,
  highlights = {
    ['Prefix'] = base.statusline_prefix,
    ['CWD'] = base.statusline_cwd,
    ['Path'] = base.statusline_path,
    ['Branch'] = base.statusline_branch,
    ['Diff'] = base.statusline_diff,
    ['Macro'] = base.key,
    ['FileType'] = base.statusline_filetype,
    ['Lines'] = base.statusline_lines,
    ['Error'] = inherit(base.error, { bg = base.statusline.bg }),
    ['Warn'] = inherit(base.warn, { bg = base.statusline.bg }),
    ['Info'] = inherit(base.info, { bg = base.statusline.bg }),
    ['Hint'] = inherit(base.hint, { bg = base.statusline.bg }),
    ['Normal'] = { fg = colors.cyan, bold = true },
    ['Visual'] = { fg = colors.green, bold = true },
    ['Select'] = { fg = colors.green, bold = true },
    ['Insert'] = { fg = colors.purple, bold = true },
    ['Replace'] = { fg = colors.red, bold = true },
    ['Command'] = { fg = colors.yellow, bold = true },
    ['Prompt'] = { fg = colors.white3, bold = true },
    ['Shell'] = { fg = colors.green, bold = true },
    ['Limbo'] = { fg = colors.white3, bold = true },
  },
}

--- @type Highlights
local tabline_highlights = {
  prefix = 'TabLine',
  base = base.tabline,
  highlights = {
    ['Tab'] = base.tab,
    ['TabNC'] = base.tab_inactive,
    ['Buffer'] = base.buffer,
    ['BufferNC'] = base.buffer_inactive,
  },
}

--- @type Highlights
local gaslighting_highlights = {
  prefix = 'Gaslighting',
  highlights = {
    ['GaslightingUnderline'] = { fg = colors.gray1 },
  },
}

vim.g.colors_name = 'bodby'
vim.cmd.highlight('clear')
vim.cmd.syntax('reset')

--- List of all the highlight groups to apply.
--- You can comment out the ones you don't need.
---
--- @type table<string, Highlights>[]
local all = {
  highlights,
  treesitter_highlights,
  alpha_highlights,
  blink_highlights,
  telescope_highlights,
  render_md_highlights,
  statusline_highlights,
  tabline_highlights,
  -- gaslighting_highlights,
}

for _, v in ipairs(all) do
  local prefix = v.prefix or ''
  local b = v.base or { }
  for k, opts in pairs(v.highlights) do
    hl(prefix .. k, inherit(b, opts))
  end
end

vim.g.terminal_color_0 = colors.gray1
vim.g.terminal_color_1 = colors.red
vim.g.terminal_color_2 = colors.green
vim.g.terminal_color_3 = colors.yellow
vim.g.terminal_color_4 = colors.blue
vim.g.terminal_color_5 = colors.purple
vim.g.terminal_color_6 = colors.cyan
vim.g.terminal_color_7 = colors.white2
vim.g.terminal_color_8 = colors.white3
vim.g.terminal_color_9 = colors.red
vim.g.terminal_color_10 = colors.green
vim.g.terminal_color_11 = colors.yellow
vim.g.terminal_color_12 = colors.blue
vim.g.terminal_color_13 = colors.purple
vim.g.terminal_color_14 = colors.cyan
vim.g.terminal_color_15 = colors.white1
