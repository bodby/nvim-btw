--- @type plugin_config
return {
  event = "FileType",
  pattern = "markdown",
  mappings = {
    ["<Leader>m"] = {
      modes = "n",
      callback = function()
        require("render-markdown").toggle()
      end
    }
  },

  opts = {
    render_modes = { "n", "c", "t" },
    anti_conceal = { enabled = false },

    win_options = {
      conceallevel = {
        default = vim.wo.conceallevel,
        rendered = 3
      },

      concealcursor = {
        default = vim.wo.concealcursor,
        rendered = "nc"
      }
    },

    -- TODO: Blockquote icon.
    quote = {
      icon = "|"
    },

    -- TODO: 'quote_icon's and remove unused callouts.
    --       Setting 'quote_icon' may not be necessary if this uses the default
    --       blockquote one.
    callout = {
      note = { rendered = "Note" },
      tip = { rendered = "Tip" },
      important = { rendered = "Important" },
      warning = { rendered = "Warning" },
      caution = { rendered = "Caution" },
      abstract = { rendered = "Abstract" },
      summary = { rendered = "Summary" },
      tldr = { rendered = "Tldr" },
      info = { rendered = "Info" },
      todo = { rendered = "Todo" },
      hint = { rendered = "Hint" },
      success = { rendered = "Success" },
      check = { rendered = "Check" },
      done = { rendered = "Done" },
      question = { rendered = "Question" },
      help = { rendered = "Help" },
      faq = { rendered = "Faq" },
      attention = { rendered = "Attention" },
      failure = { rendered = "Failure" },
      fail = { rendered = "Fail" },
      missing = { rendered = "Missing" },
      danger = { rendered = "Danger" },
      error = { rendered = "Error" },
      bug = { rendered = "Bug" },
      example = { rendered = "Example" },
      quote = { rendered = "Quote" },
      cite = { rendered = "Cite" }
    },

    checkbox = { enabled = false },

    code = {
      style = "normal",
      width = "block",
      -- TODO: 2 instead?
      left_pad = 1,
      right_pad = 1,
      border = "thick",
      inline_pad = 1
    },

    dash = {
      icon = "-"
    },

    heading = {
      -- I love changelogs.
      icons = function(context)
        return table.concat(context.sections, ".") .. ". "
      end,

      backgrounds = { },
      -- This changes the icon highlight, not the text.
      foregrounds = { "RenderMarkdownHeader" }
    },

    latex = { enabled = false },

    -- TODO: Icons?
    link = {
      footnote = {
        superscript = false,
        prefix = "[",
        suffix = "]"
      },

      image = "",
      email = "",
      hyperlink = "",
      wiki = { icon = "" },
      custom = {
        web = { icon = "" },
        discord = { icon = "" },
        github = { icon = "" },
        gitlab = { icon = "" },
        google = { icon = "" },
        neovim = { icon = "" },
        reddit = { icon = "" },
        stackoverflow = { icon = "" },
        wikipedia = { icon = "" },
        youtube = { icon = "" }
      }
    },

    bullet = { enabled = false },
    paragraph = { enabled = false },
    sign = { enabled = false },

    pipe_table = {
      preset = "round",
      alignment_indicator = "",
      cell = "trimmed"
    }
  }
}
