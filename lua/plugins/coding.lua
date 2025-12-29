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
    cond = not vim.g.vscode,
  },

  {
    "gbprod/yanky.nvim",
    keys = {
      { "Y", "<Plug>(YankyYank)$", desc = "Yank Text After Cursor" },
      { "p", "<Plug>(YankyPutBefore)", mode = { "x" }, desc = "Put Text Before Cursor" },
      { "P", "<Plug>(YankyPutAfter)", mode = { "x" }, desc = "Put Text After Cursor" },
      { "<C-v>", "<Plug>(YankyPutBefore)", mode = { "x" }, desc = "Yank Text Before Cursor" },
      { "gp", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
      { "gP", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
      { "zp", '"0<Plug>(YankyPutAfter)', mode = { "n", "x" }, desc = "Put Last Yanked Text After Cursor" },
      { "zP", '"0<Plug>(YankyPutBefore)', mode = { "n", "x" }, desc = "Put Last Yanked Text Before Cursor" },
      { "gzp", '"0<Plug>(YankyPutIndentAfterLinewise)', desc = "Put Last Yanked Text After Selection (Linewise)" },
      { "gzP", '"0<Plug>(YankyPutIndentBeforeLinewise)', desc = "Put Last Yanked Text Before Selection (Linewise)" },
      { "zgp", '"0<Plug>(YankyPutIndentAfterLinewise)', desc = "Put Last Yanked Text After Selection (Linewise)" },
      { "zgP", '"0<Plug>(YankyPutIndentBeforeLinewise)', desc = "Put Last Yanked Text Before Selection (Linewise)" },
      { "[p", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
      { "]p", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
      { ">p", false },
      { "<p", false },
      { ">P", false },
      { "<P", false },
    },
    opts = {
      ring = {
        permanent_wrapper = function(callback)
          return function(state, do_put)
            require("nvim-multi-cursor.utils").on_put_pre()
            return callback(state, do_put)
          end
        end,
      },
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
    init = function()
      -- enable cmp when reg_recording
      LazyVim.on_load("blink.cmp", function()
        -- stylua: ignore
        require("blink.cmp.config").enabled = function()
          -- disable in macros
          -- if vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= "" then return false end

          if vim.api.nvim_get_mode().mode == "c" or vim.fn.win_gettype() == "command" then return true end
          if vim.api.nvim_get_mode().mode == "t" then return false end

          local user_enabled = true
          -- User explicitly ignores default conditions
          if user_enabled == "force" then return true end

          -- Buffer explicitly set completion to true, always enable
          if user_enabled and vim.b.completion == true then return true end

          -- Buffer explicitly set completion to false, always disable
          if vim.b.completion == false then return false end

          -- Exceptions
          if user_enabled and vim.bo.filetype == "dap-repl" then return true end

          return user_enabled and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
        end
      end)
    end,

    opts = {
      keymap = {
        preset = "super-tab",
        -- stylua: ignore
        ["<C-n>"] = { function(cmp) cmp.show() end, "select_next", 'fallback_to_mappings' },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        list = { selection = { preselect = true, auto_insert = false } },
      },
    },
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
      { "<C-N>", function() require("nvim-multi-cursor.cursor").toggle_cursor_next_match() end, mode = { "n", "x" }, desc = "Add Cursor at Next Match" },
      { "<C-S-N>", function() require("nvim-multi-cursor.cursor").cursor_next_match() end, mode = { "n" }, desc = "Move Cursor to Next Match" },
      { "<Leader>mw", function() require("nvim-multi-cursor.cursor").toggle_cursor_by_flash([[\<\w*\>]]) end, mode = { "n" }, desc = "Selection Wrod To Add Cursor" },
      { "<Leader>mm", function() require("nvim-multi-cursor.cursor").toggle_cursor_by_flash() end, mode = { "n" }, desc = "Selection To Add Cursor" },
    },
    opts = {
      start_hook = function()
        vim.keymap.set("i", "<C-r>", function()
          local ch = vim.fn.getcharstr()
          local reg_pattern = [[^[a-zA-Z0-9"_%#*+\-.:/=]$]]
          if string.match(ch, reg_pattern) then
            require("nvim-multi-cursor.utils").on_put_pre(ch)
          end
          return "<C-r>" .. ch
        end, { expr = true, buffer = true })
      end,
      stop_hook = function()
        vim.keymap.del("i", "<C-r>", { buffer = true })
      end,
    },
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
        "A",
        function()
          require("vscode-multi-cursor").start_right({ no_selection = true })
        end,
        mode = "x",
      },
      {
        "c",
        function()
          if vim.fn.mode() == "\x16" then
            require("vscode-multi-cursor").start_right()
            require("vscode").action("deleteLeft")
            return "<Ignore>"
          else
            return "c"
          end
        end,
        mode = "x",
        expr = true,
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
