return {
  {
    "folke/flash.nvim",
    event = function(plugin, events)
      return "CmdlineEnter"
    end,
    keys = {

      { "f", mode = { "n", "x", "o" } },
      { "F", mode = { "n", "x", "o" } },
      { "t", mode = { "n", "x", "o" } },
      { "T", mode = { "n", "x", "o" } },
      { ";", mode = { "n", "x", "o" } },
      { ",", mode = { "n", "x", "o" } },
      { "s", false, mode = { "n", "x", "o" } },
    },
    opts = {
      label = {
        after = false,
        before = true,
      },
      modes = {
        search = { enabled = true },
        char = {
          highlight = { backdrop = false },
          char_actions = function(motion)
            return {
              [";"] = "next", -- set to `right` to always go right
              [","] = "prev", -- set to `left` to always go left
              -- clever-f style
              -- [motion:lower()] = "next",
              -- [motion:upper()] = "prev",
              -- jump2d style: same case goes next, opposite case goes prev
              [motion] = "next",
              [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
            }
          end,
          config = function(opts)
            -- autohide flash when in operator-pending mode
            opts.autohide = opts.autohide
              or vim.fn.mode(true):find("no")
              or not (vim.v.count == 0 and vim.fn.reg_executing() == "" and vim.fn.reg_recording() == "")

            -- disable jump labels when not enabled, when using a count,
            -- or when recording/executing registers
            opts.jump_labels = opts.jump_labels
              and vim.v.count == 0
              and vim.fn.reg_executing() == ""
              and vim.fn.reg_recording() == ""

            -- Show jump labels only in operator-pending mode
            -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
          end,
        },
      },
    },
  },
}
