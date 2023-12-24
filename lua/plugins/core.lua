return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin",
      defaults = {
        autocmds = not vim.g.vscode,
        keymaps = not vim.g.vscode,
      },
      news = {
        lazyvim = not vim.g.vscode,
        neovim = not vim.g.vscode,
      },
    },
  },
}
