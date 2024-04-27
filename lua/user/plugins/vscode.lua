if not vim.g.vscode then
  return {}
end

local enabled = {
  "lazy.nvim",
  "nvim-hlslens",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "flash.nvim",
  "mini.ai",
  "mini.surround",
  "yanky.nvim",
  "highlight-undo.nvim",
  "nvim-multi-cursor",
  "vscode-multi-cursor.nvim",
}

local lazy_config = require("lazy.core.config")
lazy_config.options.checker.enabled = false
lazy_config.options.change_detection.enabled = false
lazy_config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = { enable = false },
      indent = { enable = false },
    },
  },
  {
    "folke/flash.nvim",
    init = function()
      vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#f9fafe", bg = "#ff007c", italic = true, bold = true })
    end,
  },
  {
    "mrbeardad/nvim-multi-cursor",
    keys = {
      { "<C-N>", false },
      { "<C-S-N>", false },
    },
  },
}
