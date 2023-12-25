return {
  {
    "folke/persistence.nvim",
    keys = {
      { "<leader>qd", false },
      {
        "<leader>qQ",
        function()
          require("persistence").stop()
          vim.cmd.qall()
        end,
        desc = "Quit Without Saving Session",
      },
    },
  },
}
