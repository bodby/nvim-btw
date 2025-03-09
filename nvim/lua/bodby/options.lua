--- @type table<string, any>
local options = {
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  softtabstop = 2,
  textwidth = 80,

  number = true,
  relativenumber = true,
  cursorline = true,
  numberwidth = 1,
  signcolumn = "yes",
  laststatus = 3,
  showtabline = 2,

  pumheight = 16,
  scrolloff = 6,
  cmdheight = 0,
  wrap = true,
  linebreak = true,
  conceallevel = 0,
  concealcursor = "",
  mouse = "",

  hlsearch = false,
  ignorecase = true,
  smartcase = true,

  guicursor = { a = "Cursor/Cursor" },
  linespace = 6,

  list = true,
  fillchars = {
    eob = " ",
    fold = " ",

    horiz = " ",
    horizup = " ",
    horizdown = " ",
    vert = " ",
    vertleft = " ",
    vertright = " ",
    verthoriz = " "
  },

  listchars = {
    tab = "> ",
    trail = "_"
  },

  confirm = true,
  undofile = true,
  undolevels = 10000,
  shortmess = "oOstTWIcCFSqc",

  spelllang = "en",
  spellsuggest = "best"
}

--- Global options prefixed with "neovide_".
--- @type table<string, any>
local neovide_options = {
  text_gamma = 0.8,
  text_contrast = 0.2,

  padding_top = 24,
  padding_right = 24,
  padding_bottom = 24,
  padding_left = 24,

  cursor_unfocused_outline_width = 0,

  confirm_quit = true,
  no_idle = false,

  floating_shadow = false,
  floating_corner_radius = 0,
  floating_blur_amount_x = 0,
  floating_blur_amount_y = 0,

  position_animation_length = 0.2,
  scroll_animation_length = 0.2,
  scroll_animation_far_lines = 0,
  cursor_animation_length = 0.06,
  cursor_trail_size = 0.4,
  cursor_animate_in_insert_mode = true,
  cursor_animate_command_line = true
}

--- @type table<string, any>
local globals = {
  -- Unnecessary plugins.
  loaded_netrwPlugin = 1,
  loaded_netrw = 1,
  loaded_2html_plugin = 0,
  loaded_fzf = 0,
  loaded_zipPlugin = 0,
  loaded_tutor_mode_plugin = 0,

  -- Per-filetype options. See `:h filetype`.
  markdown_recommended_style = 0,
  tex_flavor = "latex"
}

for k, v in pairs(options) do
  if type(v) ~= "table" then
    vim.o[k] = v
  else
    local result = ""
    for k2, v2 in pairs(v) do
      result = result .. k2 .. ":" .. v2 .. ","
    end

    vim.o[k] = result:sub(0, #result - 1)
  end
end

if vim.g.neovide then
  for k, v in pairs(neovide_options) do
    vim.g["neovide_" .. k] = v
  end
end

for k, v in pairs(globals) do
  vim.g[k] = v
end
