return {
  {
    "akinsho/bufferline.nvim",
    event = function()
      return "LazyFile"
    end,
    keys = {
      { "<Leader>`", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
      { "<Leader>bD", "<Cmd>BufferLineSortByDirectory<CR>", desc = "Sort By Directory" },
      { "<Leader>bE", "<Cmd>BufferLineSortByExtension<CR>", desc = "Sort By Extensions" },
      { "<Leader>br", false },
      { "<Leader>bh", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers To The Left" },
      { "<Leader>bl", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers To The Right" },
    },
    opts = {
      options = {
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "Directory",
            text_align = "center",
          },
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    init = function()
      vim.opt.cmdheight = 1
    end,
    opts = {
      cmdline = {
        enabled = false,
      },
    },
  },
}
