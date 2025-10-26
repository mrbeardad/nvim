return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "powershell" } },
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
