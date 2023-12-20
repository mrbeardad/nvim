require("user.utils.lsp").kind_filter.lua = {
  --"Package", -- remove package since luals uses it for control flow structures
  "Module",
  "Namespace",
  "Struct",
  "Trait",
  "Enum",
  "Class",
  "Interface",
  "Constructor",
  "Field",
  "Property",
  "Method",
  "Function",
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "lua", "luadoc", "luap" },
    },
  },
}
