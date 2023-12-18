return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    event = "User DirOpened",
    cmd = "Neotree",
    keys = {
      { "<Leader>e", "<Cmd>Neotree<CR>", desc = "Explorer" },
    },
    opts = {},
  },
}
