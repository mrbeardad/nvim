-- Related issue https://github.com/neovim/neovim/issues/21739#issuecomment-1399405391

local M = {}

local entries = {
  first = 1,
  last = 1,
}
local active_entry = {}

local function add_entry(entry)
  entries[entries.last] = entry
  entries.last = entries.last + 1
end

local function pop_entry()
  if entries.first < entries.last then
    local entry = entries[entries.first]
    entries[entries.first] = nil
    entries.first = entries.first + 1
    return entry
  end
end

function M.sync_from()
  vim.fn.jobstart({ "win32yank.exe", "-o", "--lf" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      active_entry = { lines = data, regtype = "v" }
    end,
  })
end

M.sync_to = nil
do
  local cur_sync_job
  local function sync_next(entry)
    local chan = vim.fn.jobstart({ "win32yank.exe", "-i" }, {
      on_exit = function(_)
        local next_entry = pop_entry()
        if next_entry then
          sync_next(next_entry)
        else
          cur_sync_job = nil
        end
      end,
    })
    cur_sync_job = chan
    vim.fn.chansend(chan, entry.lines)
    vim.fn.chanclose(chan, "stdin")
  end

  M.sync_to = function()
    if cur_sync_job then
      return
    else
      local entry = pop_entry()
      if entry then
        sync_next(entry)
      end
    end
  end
end

function M.copy(regtype)
  return function(lines)
    active_entry = { lines = lines, regtype = regtype }
    add_entry(active_entry)
    M.sync_to()
  end
end

function M.paste()
  return active_entry.lines
end

-- WARN: If the system clipboard was set by another app while you are play in nvim,
-- the new clipboard content can not be catch. Usually, it will happen if you copy from
-- the terminal where nvim lives
function M.setup()
  -- Only for windows now
  if not LazyVim.is_win() then
    return
  end
  vim.g.clipboard = {
    name = "DeferClip",
    copy = {
      ["+"] = M.copy("+"),
      ["*"] = M.copy("*"),
    },
    paste = {
      ["+"] = M.paste,
      ["*"] = M.paste,
    },
  }
  vim.api.nvim_create_autocmd({ "FocusGained", "VimEnter" }, {
    group = vim.api.nvim_create_augroup("DeferClip", {}),
    callback = M.sync_from,
  })
end

return M
