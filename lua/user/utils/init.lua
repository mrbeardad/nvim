local M = {}

function M.is_floating(win_id)
  win_id = win_id or vim.api.nvim_get_current_win()
  local cfg = vim.api.nvim_win_get_config(win_id)
  if cfg.relative > "" or cfg.external then
    return true
  end
  return false
end

function M.is_real_file(bufnr, include_bt)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local bt = vim.bo[bufnr].buftype
  return bt == "" or include_bt and vim.tbl_contains(include_bt, bt)
end

local os_uname
function M.get_os_uname()
  if not os_uname then
    os_uname = vim.loop.os_uname()
  end
  return os_uname
end

function M.is_windows()
  return not not M.get_os_uname().sysname:find("Windows")
end

function M.is_macos()
  return M.get_os_uname().sysname == "Darwin"
end

function M.is_linux()
  return M.get_os_uname().sysname == "Linux"
end

function M.is_wsl()
  local uname = M.get_os_uname()
  return uname.sysname == "Linux" and not not uname.release:find("Microsoft")
end

local root_patterns = { ".git" }
local root_cache = {}
function M.workspace_root(bufnr, no_cache)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local root
  -- cache
  if not no_cache then
    root = root_cache[bufnr]
    if root then
      return root, "cache"
    end
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
function M.augroup(suffix)
  local name = "User" .. suffix
  local id = augroups[name]
  if id then
    return augroups[name]
  end
  id = vim.api.nvim_create_augroup(name, { clear = true })
  augroups[name] = id
  return id
end

function M.tbl_unique(t)
  local uniqueElements = {}
  for _, v in pairs(t) do
    if not uniqueElements[v] then
      uniqueElements[v] = true
    end
  end
  local result = {}
  for k, _ in pairs(uniqueElements) do
    table.insert(result, k)
  end

  return result
end

function M.ensure_install_tools(tools)
  local mr = require("mason-registry")
  local function ensure_installed()
    for _, t in ipairs(tools) do
      local p = mr.get_package(t)
      if not p:is_installed() then
        p:install()
      end
    end
  end
  if mr.refresh then
    mr.refresh(ensure_installed)
  else
    ensure_installed()
  end
end

return M
