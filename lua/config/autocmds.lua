-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

if vim.g.vscode then
  vim.api.nvim_del_augroup_by_name("lazyvim_checktime")
  vim.api.nvim_del_augroup_by_name("lazyvim_highlight_yank")
  vim.api.nvim_del_augroup_by_name("lazyvim_resize_splits")
  vim.api.nvim_del_augroup_by_name("lazyvim_last_loc")
  vim.api.nvim_del_augroup_by_name("lazyvim_close_with_q")
  vim.api.nvim_del_augroup_by_name("lazyvim_man_unlisted")
  vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
  vim.api.nvim_del_augroup_by_name("lazyvim_json_conceal")
  vim.api.nvim_del_augroup_by_name("lazyvim_auto_create_dir")
  return
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lazyvim_wrap_spell", { clear = true }),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

-- Automatically reload the file when it changed
require("util.watch").setup()
