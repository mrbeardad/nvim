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
        },
      },
    },
  },
}
