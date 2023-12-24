-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local utils = require("user.utils")
local lazyutils = require("lazyvim.util")

for _, name in ipairs({ "highlight_yank", "close_with_q" }) do
  vim.api.nvim_del_augroup_by_name("lazyvim_" .. name)
end

-- Trigger event LazyDir
vim.api.nvim_create_autocmd("BufEnter", {
  group = utils.augroup("LazyDir"),
  nested = true,
  callback = function(ev)
    local bufname = vim.api.nvim_buf_get_name(ev.buf)
    local stat = vim.loop.fs_stat(bufname)
    if stat and stat.type == "directory" then
      vim.api.nvim_del_augroup_by_id(utils.augroup("LazyDir"))
      vim.api.nvim_exec_autocmds("User", { pattern = "LazyDir" })
      -- trigger BufEnter again for handlers
      vim.api.nvim_exec_autocmds(ev.event, { buffer = ev.buf, data = ev.data })
    end
  end,
})

-- Trigger event BufEnterNormal and BufEnterSpecial
vim.api.nvim_create_autocmd("BufEnter", {
  group = utils.augroup("BufEnterNormal"),
  callback = function()
    -- HACK: schedule the function since the buftype may haven't been set yet
    vim.schedule(function()
      local bufnr = vim.api.nvim_get_current_buf()
      if utils.is_real_file(bufnr) then
        vim.api.nvim_exec_autocmds("User", { pattern = "BufEnterNormal" })
      else
        vim.api.nvim_exec_autocmds("User", { pattern = "BufEnterSpecial" })
      end
    end)
  end,
})

-- Trigger event BufTypeNormal and BufTypeSpecial
vim.api.nvim_create_autocmd("FileType", {
  group = utils.augroup("BufTypeNormal"),
  callback = function()
    -- HACK: schedule the function since the buftype may haven't been set yet
    vim.schedule(function()
      local bufnr = vim.api.nvim_get_current_buf()
      if utils.is_real_file(bufnr) then
        vim.api.nvim_exec_autocmds("User", { pattern = "BufTypeNormal" })
      else
        vim.api.nvim_exec_autocmds("User", { pattern = "BufTypeSpecial" })
      end
    end)
  end,
})

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

-- Close special windows with <q>
vim.api.nvim_create_autocmd("User", {
  pattern = "BufTypeSpecial",
  group = utils.augroup("EasyCloseSpecialWin"),
  callback = function(ev)
    -- q maps to qall in startup page
    local exclude = { "alpha", "dashboard" }
    if not vim.tbl_contains(exclude, vim.bo[ev.buf].filetype) then
      vim.keymap.set("n", "q", function()
        local win = vim.api.nvim_get_current_win()
        pcall(vim.api.nvim_set_current_win, vim.g.last_normal_win)
        pcall(vim.api.nvim_win_close, win, false)
      end, { buffer = ev.buf, desc = "Quit Window" })
    end
  end,
})

-- Change working directory
vim.api.nvim_create_autocmd("User", {
  pattern = "BufEnterNormal",
  group = utils.augroup("AutoChdir"),
  callback = function()
    local root = lazyutils.root()
    if root ~= vim.loop.cwd() then
      vim.fn.chdir(root)
    end
  end,
})
vim.api.nvim_create_autocmd("LspAttach", {
  group = utils.augroup("AutoChdir"),
  callback = function(ev)
    if ev.buf ~= vim.api.nvim_get_current_buf() then
      return
    end
    vim.schedule(function()
      local root = lazyutils.root()
      if root ~= vim.loop.cwd() then
        vim.fn.chdir(root)
      end
    end)
  end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = utils.augroup("AutoChdir"),
  callback = function(ev)
    if ev.buf ~= vim.api.nvim_get_current_buf() then
      return
    end
    vim.schedule(function()
      local root = lazyutils.root()
      if root ~= vim.loop.cwd() then
        vim.fn.chdir(root)
      end
    end)
  end,
})
