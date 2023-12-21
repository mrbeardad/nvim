local M = {}

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

function M.flash_select()
  local selected_labels = {}

  local find_label = function(match)
    for i, pos in ipairs(selected_labels) do
      if pos[1] == match.pos[1] and pos[2] == match.pos[2] then
        return i
      end
    end
    return nil
  end

  require("flash").jump({
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
        table.insert(selected_labels, match.pos)
      end
      state:_update()
      require("flash").jump({ continue = true })
    end,
  })

  return selected_labels
end

return M
