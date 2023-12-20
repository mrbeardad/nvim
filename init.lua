if vim.g.vscode then
  return
end

-- bootstrap plugins manager
local plugins_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(plugins_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    plugins_path,
  })
end
vim.opt.rtp:prepend(plugins_path)

-- load user configs before load plugins
vim.cmd("runtime! lua/user/configs/*.lua")

require("lazy").setup({
  -- load plugin specifics in directories
  spec = {
    { import = "user/plugins" },
    { import = "user/langs" },
    -- { import = "user/debug" },
  },
  defaults = {
    -- do not lazy load plugins by default
    lazy = false,
    -- always use the latest git commit, set to "*" for latest stable version
    version = false,
    -- disable unnecessary plugins for vscode
    cond = function()
      return true
    end,
  },
  install = {
    -- automatically install missing plugins
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "tokyonight", "catppuccin", "habamax" },
  },
  -- do not automatically check for plugin updates
  checker = { enabled = false },
  -- do not automatically check for config file changes and reload the ui
  change_detection = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    custom_keys = {
      ["o"] = {
        function(plugin)
          vim.cmd.close()
          vim.cmd("Neotree dir=" .. plugin.dir)
        end,
        desc = "Open Plugin Dir",
      },
    },
  },
})
