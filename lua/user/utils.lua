local Util = require("lazyvim.util")

local M = {}

local augroups = {}
function M.augroup(name)
  name = "User" .. name
  local id = augroups[name]
  if id then
    return augroups[name]
  end
  id = vim.api.nvim_create_augroup(name, { clear = true })
  augroups[name] = id
  return id
end

function M.is_floating(win_id)
  win_id = win_id or vim.api.nvim_get_current_win()
  local cfg = vim.api.nvim_win_get_config(win_id)
  return cfg.relative > "" or cfg.external
end

function M.is_real_file(bufnr, include_bt)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local bt = vim.bo[bufnr].buftype
  return bt == "" or include_bt and vim.tbl_contains(include_bt, bt)
end

return M
