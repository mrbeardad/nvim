return {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    keys = {
      {
        "<leader>qs",
        function()
          vim.g.minianimate_disable = true
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          vim.g.minianimate_disable = true
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
    opts = {},
  },

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
}
