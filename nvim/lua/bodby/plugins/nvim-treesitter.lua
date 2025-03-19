local options = {
  --- Whether to remove commands that modify parsers.
  --- @type boolean
  delete_user_commands = true
}

--- @type plugin_config
return {
  event = 'BufEnter',
  opts = {
    ensure_installed = { },
    auto_install = false,
    ignore_install = { 'all' },
    highlight = { enable = true },
    incremental_selection = { enable = false },
    indent = { enable = true }
  },

  post = function()
    if options.delete_user_commands then
      vim.api.nvim_del_user_command('TSInstall')
      vim.api.nvim_del_user_command('TSInstallFromGrammar')
      vim.api.nvim_del_user_command('TSInstallSync')
      vim.api.nvim_del_user_command('TSUpdate')
      vim.api.nvim_del_user_command('TSUpdateSync')
      vim.api.nvim_del_user_command('TSUninstall')
      vim.api.nvim_del_user_command('TSModuleInfo')
      vim.api.nvim_del_user_command('TSInstallInfo')
      vim.api.nvim_del_user_command('TSConfigInfo')
      vim.api.nvim_del_user_command('TSEditQuery')
      vim.api.nvim_del_user_command('TSEditQueryUserAfter')
    end
  end
}

