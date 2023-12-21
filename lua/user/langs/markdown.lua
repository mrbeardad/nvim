return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {},
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "markdown")
      table.insert(opts.ensure_installed, "markdown_inline")
      table.insert(opts.ensure_installed, "html")
      return opts
    end,
  },
}
