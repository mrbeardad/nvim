return {
  -- Modify surround objects
  {
    "echasnovski/mini.surround",
    keys = {
      { "ys", desc = "Add Surround" },
      { "s", ":<C-u>lua MiniSurround.add('visual')<CR>", mode = "x", desc = "Add Surround" },
      { "cs", desc = "Change Surround" },
      { "ds", desc = "Delete Surround" },
    },
    opts = {
      mappings = {
        add = "ys", -- Add surrounding in Normal and Visual modes
        replace = "cs", -- Replace surrounding
        delete = "ds", -- Delete surrounding
        find = "", -- Find surrounding (to the right)
        find_left = "", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        update_n_lines = "", -- Update `n_lines`
        suffix_next = "n", -- Suffix to search with "next" method
        suffix_last = "N", -- Suffix to search with "prev" method
      },
      search_method = "cover",
      n_lines = 100,
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
      vim.keymap.del("x", "ys")
    end,
  },

  -- Better yank/paste
  {
    "gbprod/yanky.nvim",
    dependencies = { { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") } },
    keys = {
      {
        "<Leader>sy",
        function()
          require("telescope").extensions.yank_history.yank_history({})
        end,
        desc = "Open Yank History",
      },
      {
        "<Leader>sp",
        function()
          require("telescope").extensions.yank_history.yank_history({})
        end,
        desc = "Open Yank History",
      },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", "<Plug>(YankyPutAfter)`[", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)`[", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)`[", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)`[", desc = "Put indented before cursor (linewise)" },
      { "zp", '"0<Plug>(YankyPutAfter)`[', mode = { "n", "x" }, desc = "Put last yanked text after cursor" },
      { "zP", '"0<Plug>(YankyPutBefore)`[', mode = { "n", "x" }, desc = "Put last yanked text before cursor" },
      { "zgp", '"0<Plug>(YankyGPutAfter)', mode = { "n", "x" }, desc = "Put last yanked text after selection" },
      { "zgP", '"0<Plug>(YankyGPutBefore)', mode = { "n", "x" }, desc = "Put last yanked text before selection" },
      { "z]p", '"0<Plug>(YankyPutIndentAfterLinewise)`[', desc = "Put indented after cursor (linewise)" },
      { "z[p", '"0<Plug>(YankyPutIndentBeforeLinewise)`[', desc = "Put indented before cursor (linewise)" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
    },
    opts = {
      highlight = { timer = 150 },
      ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
    },
  },

  -- Multiple cursor to modify matched pattern
  {
    "brenton-leighton/multiple-cursors.nvim",
    keys = {
      { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" } },
      { "ma", "<Cmd>MultipleCursorsAddToWordUnderCursor<CR>", mode = { "n", "v" } },
    },
    opts = {},
  },

  -- Undo history
  {
    "debugloop/telescope-undo.nvim",
    keys = { { "<Leader>su", "<Cmd>Telescope undo<CR>", desc = "Undo History" } },
    config = function()
      require("telescope").load_extension("undo")
    end,
  },
}
