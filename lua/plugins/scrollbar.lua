return {
  -- Scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "LazyFile",
    opts = {
      -- show_in_active_only = true, -- This will cause blink
      hide_if_all_visible = true,
      handle = {
        highlight = "ScrollbarHandle",
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true, -- Requires gitsigns
        search = false, -- Requires hlslens
      },
      marks = {
        Cursor = { text = "—" },
        Search = { text = { "—", "󰇼" } },
        Error = { text = { "—", "󰇼" } },
        Warn = { text = { "—", "󰇼" } },
        Info = { text = { "—", "󰇼" } },
        Hint = { text = { "—", "󰇼" } },
        Misc = { text = { "—", "󰇼" } },
        GitAdd = { text = "▎" },
        GitChange = { text = "▎" },
        GitDelete = { text = "▁" },
      },
    },
  },
}
