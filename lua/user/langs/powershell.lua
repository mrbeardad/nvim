local utils = require("user.utils")
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "powershell" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        powershell_es = {
          bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
          settings = {
            powershell = {
              codeFormatting = {
                OpenBraceOnSameLine = true,
                NewLineAfterOpenBrace = true,
                IgnoreOneLineBlock = true,
              },
            },
          },
        },
      },
    },
  },
}
