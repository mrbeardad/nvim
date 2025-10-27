return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<F2>", vim.lsp.buf.rename },
          },
        },
      },
    },
  },
}
