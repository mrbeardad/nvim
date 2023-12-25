-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
if vim.g.vscode then
  return
end

local utils = require("user.utils")
local lazyutils = require("lazyvim.util")

-- Remenber the last normal winid
vim.g.last_normal_win = 0
vim.api.nvim_create_autocmd("WinLeave", {
  group = utils.augroup("LastNormalWin"),
  callback = function()
    local winid = vim.api.nvim_get_current_win()
    if not utils.is_floating(winid) and utils.is_real_file() then
      vim.g.last_normal_win = winid
    end
  end,
})

local current_buf = 0
-- Change working directory
vim.api.nvim_create_autocmd("BufEnter", {
  group = utils.augroup("AutoChdir"),
  callback = function(ev)
    current_buf = ev.buf
    if utils.is_real_file(ev.buf) then
      local root = lazyutils.root()
      if root ~= vim.loop.cwd() then
        vim.fn.chdir(root)
      end
    end
  end,
})
vim.api.nvim_create_autocmd("LspAttach", {
  group = utils.augroup("AutoChdir"),
  callback = function(ev)
    if ev.buf == current_buf then
      -- Schedule it since root cache will be clean on LspAttach
      vim.schedule(function()
        local root = lazyutils.root()
        if root ~= vim.loop.cwd() then
          vim.fn.chdir(root)
        end
      end)
    end
  end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = utils.augroup("AutoChdir"),
  callback = function(ev)
    if ev.buf == current_buf then
      vim.schedule(function()
        local root = lazyutils.root()
        if root ~= vim.loop.cwd() then
          vim.fn.chdir(root)
        end
      end)
    end
  end,
})
