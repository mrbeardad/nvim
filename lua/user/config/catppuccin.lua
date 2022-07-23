local M = {}

M.config = function()
  local catppuccin = require("catppuccin")
  catppuccin.setup({
    transparent_background = lvim.transparent_window,
    dim_inactive = {
      enabled = true,
    },
    styles = {
      comments = { "italic" },
      strings = { "italic" },
      keywords = { "italic" },
      functions = { "italic" },
      numbers = { "italic" },
    },
    integrations = {
      lsp_trouble = true,
      nvimtree = {
        transparent_panel = lvim.transparent_window,
      },
      which_key = true,
      ts_rainbow = true,
      hop = true,
    },
  })
  vim.g.catppuccin_flavour = "macchiato"
end

return M
