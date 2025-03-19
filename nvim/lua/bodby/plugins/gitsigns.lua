local gitsigns = require('gitsigns')

-- TODO: Full line and word diffs with translucent backgrounds.

--- @type plugin_config
return {
  event = 'BufEnter',
  mappings = {
    ['<Leader>g'] = {
      modes = 'n',
      callback = function()
        gitsigns.toggle_deleted()
        gitsigns.toggle_signs()
      end
    }
  },

  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '-' },
      topdelete = { text = '-' },
      changedelete = { text = '~' },
      untracked = { text = '?' }
    },

    signs_staged_enable = false,
    signcolumn = false,
    numhl = false,
    linehl = false,
    word_diff = false
  }
}
