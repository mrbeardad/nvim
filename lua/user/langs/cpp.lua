return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "c", "cpp", "cmake" })
    end,
  },

  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    opts = {},
    config = function() end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          keys = {
            { "<A-o>", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
            { "<Leader>ls", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
        },
        cmake = {},
      },
      setup = {
        clangd = function(_, opts)
          require("clangd_extensions").setup({ server = opts })
          return false
        end,
      },
    },
  },
}
