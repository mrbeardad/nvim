return {
  {
    "nvim-mini/mini.ai",
    event = function()
      return {}
    end,
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
      { "g[", mode = { "n", "x", "o" } },
      { "g]", mode = { "n", "x", "o" } },
    },
  },

  {
    "nvim-mini/mini.surround",
    keys = {
      { "s", ":<C-U>lua MiniSurround.add('visual')<CR>", mode = "x", desc = "Add Surround" },
      { "ys", false, mode = "x" },
    },
    opts = {
      mappings = {
        add = "ys", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        replace = "cs", -- Replace surrounding
      },
    },
    config = function(_, opts)
      local ts_input = require("mini.surround").gen_spec.input.treesitter
      LazyVim.merge(
        opts,
        { custom_surroundings = { u = { input = ts_input({ outer = "@call.outer", inner = "@call.inner" }) } } }
      )
      require("mini.surround").setup(opts)
      vim.keymap.del("x", "ys")
    end,
  },

  {
    "nvim-mini/mini.pairs",
    event = function()
      return "InsertEnter"
    end,
  },

  {
    "gbprod/yanky.nvim",
    -- stylua: ignore
    keys = {
      { "Y", "<Plug>(YankyYank)$", desc = "Yank Text After Cursor" },
      { "gp", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
      { "gP", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
      { "zp", '"0<Plug>(YankyPutAfter)', mode = { "n", "x" }, desc = "Put Last Yanked Text After Cursor" },
      { "zP", '"0<Plug>(YankyPutBefore)', mode = { "n", "x" }, desc = "Put Last Yanked Text Before Cursor" },
      { "gzp", '"0<Plug>(YankyPutIndentAfterLinewise)', desc = "Put Last Yanked Text After Selection (Linewise)" },
      { "gzP", '"0<Plug>(YankyPutIndentBeforeLinewise)', desc = "Put Last Yanked Text Before Selection (Linewise)" },
      { "zgp", '"0<Plug>(YankyPutIndentAfterLinewise)', desc = "Put Last Yanked Text After Selection (Linewise)" },
      { "zgP", '"0<Plug>(YankyPutIndentBeforeLinewise)', desc = "Put Last Yanked Text Before Selection (Linewise)" },
      { ">p", false },
      { "<p", false },
      { ">P", false },
      { "<P", false },
    },
  },

  {
    "folke/ts-comments.nvim",
    event = function()
      return {}
    end,
  },
  {
    "nvim-mini/mini.comment",
    event = function()
      return {}
    end,
    keys = {
      { "<C-_>", "gcc", remap = true, desc = "Comment line" },
      { "<C-_>", "gc", mode = "x", remap = true, desc = "Comment selection" },
      { "<C-_>", "<Cmd>normal gcc<CR>", mode = "i", desc = "Comment line" },
    },
  },

  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
        -- stylua: ignore
        ["<C-n>"] = { function(cmp) cmp.show() end, "select_next", },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<F2>", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
    end,
  },

  -- Multiple cursor to modify matched pattern
  {
    "mrbeardad/nvim-multi-cursor",
    -- stylua: ignore
    keys = {
      { "<C-J>", function() require("nvim-multi-cursor.cursor").toggle_cursor_downward() end, mode = { "n" }, desc = "Add Cursor Downward" },
      { "<C-S-J>", function() require("nvim-multi-cursor.cursor").cursor_down() end, mode = { "n" }, desc = "Move Cursor Down" },
      { "<C-K>", function() require("nvim-multi-cursor.cursor").toggle_cursor_upward() end, mode = { "n" }, desc = "Add Cursor Upward" },
      { "<C-S-K>", function() require("nvim-multi-cursor.cursor").cursor_up() end, mode = { "n" }, desc = "Move Cursor Up" },
      { "<C-N>", function() require("nvim-multi-cursor.cursor").toggle_cursor_next_match() end, mode = { "n", "x" }, desc = "Add Cursor Upward" },
      { "<C-S-N>", function() require("nvim-multi-cursor.cursor").cursor_next_match() end, mode = { "n" }, desc = "Move Cursor Up" },
      { "<Leader>mw", function() require("nvim-multi-cursor.cursor").toggle_cursor_by_flash([[\<\w*\>]]) end, mode = { "n" }, desc = "Selection Wrod To Add Cursor" },
      { "<Leader>mm", function() require("nvim-multi-cursor.cursor").toggle_cursor_by_flash() end, mode = { "n" }, desc = "Selection To Add Cursor" },
    },
    opts = {},
    vscode = true,
  },

  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    lazy = true,
    keys = {
      {
        "I",
        function()
          require("vscode-multi-cursor").start_left({ no_selection = true })
        end,
        mode = "x",
      },
      {
        "I",
        function()
          if #require("vscode-multi-cursor.state").cursors == 0 then
            return "I"
          end
          require("vscode-multi-cursor").start_left()
          return "<Ignore>"
        end,
        mode = "n",
        expr = true,
      },
      {
        "A",
        function()
          require("vscode-multi-cursor").start_right({ no_selection = true })
        end,
        mode = "x",
      },
      {
        "A",
        function()
          if #require("vscode-multi-cursor.state").cursors == 0 then
            return "A"
          end
          require("vscode-multi-cursor").start_right()
          return "<Ignore>"
        end,
        mode = "n",
        expr = true,
      },
      {
        "c",
        function()
          if vim.fn.mode() == "\x16" then
            require("vscode-multi-cursor").start_right()
            require("vscode-neovim").action("deleteLeft")
            return "<Ignore>"
          else
            return "c"
          end
        end,
        mode = "x",
        expr = true,
      },
      {
        "<Leader>m",
        function()
          return require("vscode-multi-cursor").create_cursor()
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Create Cursor",
      },
      -- {
      --   "<Leader>ms",
      --   function()
      --     if vim.api.nvim_get_hl(0, { name = "FlashLabelUnselected" }).bg == nil then
      --       vim.api.nvim_set_hl(
      --         0,
      --         "FlashLabelUnselected",
      --         { fg = "#b9bbc4", bg = "#bd0c69", italic = true, bold = true }
      --       )
      --     end
      --     keymap.toggle_cursor_by_flash()
      --   end,
      --   mode = "n",
      --   desc = "Create cursor using flash",
      -- },
      -- {
      --   "mcw",
      --   function()
      --     require("vscode-multi-cursor").flash_word()
      --   end,
      --   mode = "n",
      --   desc = "Create selection using flash",
      -- },
      {
        "<Esc>",
        function()
          if #require("vscode-multi-cursor.state").cursors ~= 0 then
            require("vscode-multi-cursor").cancel()
            return "<Ignore>"
          else
            return "<Cmd>nohlsearch|diffupdate|normal! <C-L><CR><Esc>"
          end
        end,
        expr = true,
        mode = "n",
        desc = "Cancel/Clear All Cursors",
      },
      {
        "[m",
        function()
          require("vscode-multi-cursor").prev_cursor()
        end,
        mode = "n",
        desc = "Goto Prev Cursor",
      },
      {
        "]m",
        function()
          require("vscode-multi-cursor").next_cursor()
        end,
        mode = "n",
        desc = "Goto Next Cursor",
      },
      {
        "<C-S-L>",
        function()
          require("vscode-multi-cursor").selectHighlights()
        end,
        mode = { "n", "x", "i" },
        desc = "Select All Find Match",
      },
    },
    opts = {
      default_mappings = false,
    },
    vscode = true,
    cond = not not vim.g.vscode,
  },
}
