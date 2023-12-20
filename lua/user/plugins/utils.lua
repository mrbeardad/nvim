return {
  -- Basic lib
  { "nvim-lua/plenary.nvim", lazy = true },
  -- Icons lib
  { "nvim-tree/nvim-web-devicons", lazy = true },
  -- UI lib
  { "MunifTanjim/nui.nvim", lazy = true },

  -- Save and restore session
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qQ",
        function()
          require("persistence").stop()
          vim.cmd.qall()
        end,
        desc = "Quit Without Saving Session",
      },
    },
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "globals", "skiprtp", "folds" },
    },
  },

  -- Better bd
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<Leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
    },
    opts = {},
  },

  -- Finds and lists all of the TODO, FIX, PERF etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    event = "User LazyFile",
    cmd = { "TodoTelescope" },
    -- stylua: ignore
    keys = {
      { "]T", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[T", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<Leader>st", "<Cmd>TodoTelescope<CR>", desc = "Todos" },
      { "<Leader>sT", "<Cmd>TodoTelescope keywords=TODO,FIX,PERF<CR>", desc = "TODO/FIX/PERF" },
    },
    opts = {},
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
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "zp", '"0<Plug>(YankyPutAfter)', mode = { "n", "x" }, desc = "Put last yanked text after cursor" },
      { "zP", '"0<Plug>(YankyPutBefore)', mode = { "n", "x" }, desc = "Put last yanked text before cursor" },
      { "zgp", '"0<Plug>(YankyGPutAfter)', mode = { "n", "x" }, desc = "Put last yanked text after selection" },
      { "zgP", '"0<Plug>(YankyGPutBefore)', mode = { "n", "x" }, desc = "Put last yanked text before selection" },
      { "z]p", '"0<Plug>(YankyPutIndentAfterLinewise)', desc = "Put indented after cursor (linewise)" },
      { "z[p", '"0<Plug>(YankyPutIndentBeforeLinewise)', desc = "Put indented before cursor (linewise)" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
    },
    opts = {
      highlight = { timer = 150 },
      ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
    },
  },
}
