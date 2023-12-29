if vim.g.vscode then
  require("user.configs.vscode")
else
  require("user.configs.options")
  require("user.configs.autocmds")
  require("user.configs.keymaps")
end
