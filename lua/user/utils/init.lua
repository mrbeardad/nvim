local M = {}

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

M.os_uname = vim.loop.os_uname()

function M.is_windows()
  return M.os_uname.sysname:find("Windows") ~= nil
end

function M.is_macos()
  return M.os_uname.sysname == "Darwin"
end

function M.is_linux()
  return M.os_uname.sysname == "Linux"
end

function M.is_wsl()
  return M.os_uname.sysname == "Linux" and M.os_uname.release:find("Microsoft") ~= nil
end

local root_patterns = { ".git", ".svn" }
local root_cache = {}
function M.workspace_root(no_cache)
  local root
  local bufnr = vim.api.nvim_get_current_buf()
  -- cache
  if not no_cache and root_cache[bufnr] then
    return root_cache[bufnr], "cache"
  end
  -- cwd, the buffer has not been written yet, do not cache it
  local bufname = vim.loop.fs_realpath(vim.api.nvim_buf_get_name(bufnr))
  if not bufname then
    return vim.loop.cwd(), "cwd"
  end
  -- lsp
  local folders = vim.lsp.buf.list_workspace_folders()
  for _, f in ipairs(folders) do
    f = vim.loop.fs_realpath(f) .. (M.is_windows() and "\\" or "/")
    if vim.startswith(bufname, f) then
      root_cache[bufnr] = f
      return f, "lsp"
    end
  end
  -- pattern
  root = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true, path = vim.fs.dirname(bufname) })[1])
  if root then
    root_cache[bufnr] = root
    return root, "pattern"
  end
  -- buffer dir
  root = vim.fn.fnamemodify(bufname, ":h")
  root_cache[bufnr] = root
  return root, "buffer"
end

function M.on_load(name, fn)
  local Config = require("lazy.core.config")
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

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

function M.tbl_unique(t)
  local uniq_elem = {}
  for _, v in pairs(t) do
    if not uniq_elem[v] then
      uniq_elem[v] = true
    end
  end
  local result = {}
  for k, _ in pairs(uniq_elem) do
    table.insert(result, k)
  end

  return result
end

function M.get_visual_text()
  vim.api.nvim_feedkeys("\027", "nx", false)
  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")
  return vim.api.nvim_buf_get_text(0, start_pos[1] - 1, start_pos[2], end_pos[1] - 1, end_pos[2] + 1, {})
end

return M
