return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          settings = {
            bashIde = {
              shellcheckPath = LazyVim.is_win() and vim.fn.stdpath("data") .. "\\mason\\bin\\shellcheck.cmd" or nil,
            },
          },
        }, -- Automatically call shellcheck
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "shfmt" } },
  },
}
