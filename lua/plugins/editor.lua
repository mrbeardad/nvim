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
      { "n", mode = { "n", "x", "o" } },
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
        },
      },
    },
  },
}
