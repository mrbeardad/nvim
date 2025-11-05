local M = {}

function M.goto_explorer_window()
  for index, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local cfg = vim.api.nvim_win_get_config(win_id)
    if cfg.zindex == 33 and cfg.title == nil then
      vim.api.nvim_set_current_win(win_id)
      return true
    end
  end
  return false
end

function M.goto_terminal_window()
  for index, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win_id)
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_set_current_win(win_id)
      return true
    end
  end
  return false
end

function M.open_in_system(path)
  local sysname = vim.uv.os_uname().sysname
  if sysname:find("Windows") ~= nil then
    os.execute("start " .. path)
  elseif sysname == "Linux" then
    os.execute("xdg-open " .. path)
  elseif sysname == "Darwin" then
    os.execute("open " .. path)
  else
    vim.notify("Unsupported System open", "error")
  end
end

function M.switch_window(next)
  return function()
    local cur_win = vim.api.nvim_get_current_win()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local start
    local idx = 0
    local step = next and 1 or -1
    while true do
      local win = wins[idx + 1]
      idx = (idx + step) % #wins
      if not start then
        start = win == cur_win
      else
        if win == cur_win then
          return
        end
        if vim.api.nvim_win_get_config(win).relative == "" then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
    end
  end
end

return M
