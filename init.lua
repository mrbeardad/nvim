-- Bootstrap plugins manager
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazy_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazy_path,
  })
end
vim.opt.rtp:prepend(lazy_path)

-- Load user configs before load plugins
require("user.configs")

require("lazy").setup({
  -- Load plugin specifics in directories
  spec = {
    { import = "user/plugins" },
    { import = "user/langs" },
  },
  install = {
    -- Try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "tokyonight", "habamax" },
  },
  change_detection = {
    -- Do not automatically check for config file changes and reload the ui
    enabled = false,
  },
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
})
