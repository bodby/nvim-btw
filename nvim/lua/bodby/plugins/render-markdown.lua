local render_md = require('render-markdown')

--- @type Plugin
return {
  event = 'FileType',
  pattern = 'markdown',
  mappings = {
    ['<Leader>m'] = {
      modes = 'n',
      callback = render_md.toggle,
    },
  },
  opts = {
    render_modes = { 'n', 'c', 't' },
    anti_conceal = { enabled = false },
    completions = {
      lsp = { enabled = true },
    },
    win_options = {
      conceallevel = {
        default = vim.wo.conceallevel,
        rendered = 3,
      },
      concealcursor = {
        default = vim.wo.concealcursor,
        rendered = 'nc',
      },
    },
    quote = { enabled = false },
    checkbox = { enabled = false },
    code = {
      style = 'normal',
      width = 'block',
      -- TODO: 2 instead?
      left_pad = 1,
      right_pad = 1,
      border = 'thick',
      inline_pad = 1
    },

    dash = { icon = '-' },
    heading = {
      -- I love changelogs.
      icons = function(context)
        return table.concat(context.sections, '.') .. '. '
      end,

      backgrounds = { },
      -- This changes the icon highlight, not the text.
      foregrounds = { 'RenderMarkdownHeader' }
    },

    latex = { enabled = false },
    -- TODO: Icons?
    link = {
      footnote = {
        superscript = true
        -- prefix = '[',
        -- suffix = ']'
      },

      image = '',
      email = '',
      hyperlink = '',
      wiki = { icon = '' },
      custom = {
        web = { icon = '' },
        discord = { icon = '' },
        github = { icon = '' },
        gitlab = { icon = '' },
        google = { icon = '' },
        neovim = { icon = '' },
        reddit = { icon = '' },
        stackoverflow = { icon = '' },
        wikipedia = { icon = '' },
        youtube = { icon = '' }
      }
    },

    bullet = { enabled = false },
    paragraph = { enabled = false },
    sign = { enabled = false },
    pipe_table = {
      preset = 'round',
      alignment_indicator = '',
      cell = 'trimmed'
    }
  }
}
