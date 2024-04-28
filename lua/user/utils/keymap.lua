local utils = require("user.utils")

local M = {}

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
        if utils.is_real_file(vim.api.nvim_win_get_buf(win), { "help" }) then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
    end
  end
end

function M.zoom_window()
  local cur_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_var("non_float_total", 0)
  vim.cmd('windo if &buftype != "nofile" | let g:non_float_total += 1 | endif')
  vim.api.nvim_set_current_win(cur_win or 0)
  if vim.api.nvim_get_var("non_float_total") == 1 then
    if vim.fn.tabpagenr("$") == 1 then
      return
    end
    vim.cmd("tabclose")
  else
    local last_cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd("tabedit %:p")
    vim.api.nvim_win_set_cursor(0, last_cursor)
  end
end

function M.toggle_search_pattern(flag)
  return function()
    local t = vim.fn.getcmdtype()
    if vim.api.nvim_get_mode().mode:sub(1, 1) ~= "c" and t ~= "/" and t ~= "?" then
      return
    end

    local pattern = vim.fn.getcmdline()
    if not pattern or pattern:sub(1, 1) == t then
      return
    end

    local flag_w1, flag_w2, flag_c, flag_r
    local flag_end
    local i = 1
    while i <= #pattern do
      local c = pattern:sub(i, i)
      if flag_end then
        if c == "\\" then
          i = i + 1
          if i > #pattern then
            break
          end
          local c2 = pattern:sub(i, i)
          if c2 == ">" and not flag_r and i == #pattern then
            flag_w2 = true
          end
        else
          if c == ">" and flag_r and i == #pattern then
            flag_w2 = true
          end
        end
        goto continue
      end

      if c == "\\" then
        i = i + 1
        if i > #pattern then
          break
        end
        local c2 = pattern:sub(i, i)
        if c2 == "<" and not flag_r then
          flag_w1 = true
        elseif c2 == "C" then
          flag_c = true
        elseif c2 == "v" then
          flag_r = true
        else
          flag_end = i - 1
          i = i - 2
        end
      else
        if c == "<" and flag_r then
          flag_w1 = true
        else
          flag_end = i
          i = i - 1
        end
      end

      ::continue::
      i = i + 1
    end

    local w2_len
    if flag_w2 then
      w2_len = flag_r and 1 or 2
    else
      w2_len = 0
    end

    pattern = flag_end and pattern:sub(flag_end, #pattern - w2_len) or ""
    if flag == "w" and (not flag_w1 or not flag_w2) or flag ~= "w" and flag_w1 and flag_w2 then
      w2_len = flag_r and 1 or 2
      pattern = (flag_r and "<" or "\\<") .. pattern .. (flag_r and ">" or "\\>")
    else
      w2_len = 0
    end
    if flag == "c" and not flag_c or flag ~= "c" and flag_c then
      pattern = "\\C" .. pattern
    end
    if flag == "r" and not flag_r or flag ~= "r" and flag_r then
      pattern = "\\v" .. pattern
    end

    vim.fn.setcmdline(pattern, #pattern + 1 - w2_len)
    -- vscode does not trigger flash after setcmdline
    if vim.g.vscode then
      vim.api.nvim_input(" <BS>")
    end
  end
end

local cache_empty_line
function M.put_empty_line(put_above)
  -- This has a typical workflow for enabling dot-repeat:
  -- - On first call it sets `operatorfunc`, caches data, and calls
  --   `operatorfunc` on current cursor position.
  -- - On second call it performs task: puts `v:count1` empty lines
  --   above/below current line.
  if type(put_above) == "boolean" then
    vim.o.operatorfunc = "v:lua.require'user.utils.keymap'.put_empty_line"
    cache_empty_line = { put_above = put_above }
    return "g@l"
  end

  local target_line = vim.fn.line(".") - (cache_empty_line.put_above and 1 or 0)
  vim.fn.append(target_line, vim.fn["repeat"]({ "" }, vim.v.count1))
end

local terminals = {}
-- Opens a floating terminal (interactive by default)
function M.open_term(cmd, opts)
  -- Powershell is slow, so delay settins it here instead of on startup
  cmd = cmd or vim.fn.executable("pwsh") and "pwsh" or cmd
  opts = vim.tbl_deep_extend("force", {
    ft = "lazyterm",
    size = { width = 0.9, height = 0.9 },
  }, opts or {}, { persistent = true })

  local termkey = vim.inspect({ cmd = cmd or "shell", cwd = opts.cwd, env = opts.env, count = vim.v.count1 })

  if terminals[termkey] and terminals[termkey]:buf_valid() then
    terminals[termkey]:toggle()
  else
    terminals[termkey] = require("lazy.util").float_term(cmd, opts)
    local buf = terminals[termkey].buf
    vim.b[buf].lazyterm_cmd = cmd
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = buf,
      callback = function()
        vim.cmd.startinsert()
      end,
    })
  end

  return terminals[termkey]
end

function M.flash_telescope(prompt_bufnr)
  require("flash").jump({
    pattern = "^",
    search = {
      mode = "search",
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
        end,
      },
    },
    action = function(match)
      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      picker:set_selection(match.pos[1] - 1)
    end,
  })
end

function M.toggle_cursor_by_flash(pattern)
  local selected_labels = {}

  local function find_label(match)
    for i, pos in ipairs(selected_labels) do
      if pos[1] == match.pos[1] and pos[2] == match.pos[2] then
        return i
      end
    end
    return nil
  end

  require("flash").jump({
    pattern = pattern,
    search = {
      mode = "search",
    },
    jump = {
      pos = "range",
    },
    label = {
      format = function(opts)
        return {
          {
            opts.match.label,
            find_label(opts.match) and opts.hl_group or "FlashLabelUnselected",
          },
        }
      end,
    },
    action = function(match, state)
      local i = find_label(match)
      if i then
        table.remove(selected_labels, i)
      else
        table.insert(selected_labels, { match.pos[1], match.pos[2], match.end_pos[1], match.end_pos[2] })
      end
      state:_update()
      require("flash").jump({ continue = true })
    end,
  })

  vim.schedule(function()
    for index, pos in ipairs(selected_labels) do
      require("vscode-multi-cursor.state").add_cursor(
        require("vscode-multi-cursor.cursor").new({ pos[1], pos[2] }, { pos[3], pos[4] })
      )
    end
  end)
end

return M
