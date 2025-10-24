return {
  -- Basic lib
  { "nvim-lua/plenary.nvim", lazy = true },
  -- Icons lib
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  -- UI lib
  { "MunifTanjim/nui.nvim", lazy = true },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      { "<Leader>bd", function () require("snacks").bufdelete.delete() end },
    },
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      indent = { enabled = true },
    },
    config = function(_, opts)
      local notify = vim.notify
      require("snacks").setup(opts)
      -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
      -- this is needed to have early notifications show up in noice history
      vim.notify = notify
    end,
  },

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
      -- options = vim.opt.sessionoptions:get(),
    },
  },

  -- Finds and lists all of the TODO, FIX, PERF etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    event = "User LazyFile",
    cmd = { "TodoTelescope" },
    -- stylua: ignore
    keys = {
      { "<Leader>st", "<Cmd>TodoTelescope<CR>", desc = "Todos" },
      { "<Leader>sT", "<Cmd>TodoTelescope keywords=TODO,FIX,PERF<CR>", desc = "TODO/FIX/PERF" },
    },
    opts = {},
  },
}
