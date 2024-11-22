if not vim.g.vscode then
  return {}
end

local enabled = {
  "lazy.nvim",
  "nvim-hlslens",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "flash.nvim",
  "mini.ai",
  "mini.indentscope",
  "mini.surround",
  "sqlite.lua",
  "yanky.nvim",
  "highlight-undo.nvim",
  "nvim-multi-cursor",
  "vscode-multi-cursor.nvim",
}

local lazy_config = require("lazy.core.config")
lazy_config.options.checker.enabled = false
lazy_config.options.change_detection.enabled = false
lazy_config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = { enable = false },
      indent = { enable = false },
    },
  },
  {
    "folke/flash.nvim",
    init = function()
      vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#f9fafe", bg = "#ff007c", italic = true, bold = true })
    end,
  },
  {
    "mrbeardad/nvim-multi-cursor",
    keys = {
      { "<C-N>", false, mode = { "n", "x" } },
      { "<C-S-N>", false, mode = { "n", "x" } },
      { "<C-S-L>", false, mode = { "n", "x" } },
    },
  },
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
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
        "<C-N>",
        function()
          require("vscode-multi-cursor").addSelectionToNextFindMatch()
        end,
        mode = { "n", "x", "i" },
        desc = "Select Next Find Match",
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
  },
}
