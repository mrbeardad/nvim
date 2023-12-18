return {
  {
    "vimpostor/vim-lumen",
    priority = 1000,
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      dim_inactive = true,
      styles = {
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "normal", -- style for floating windows
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
