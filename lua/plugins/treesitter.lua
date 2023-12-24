return {
  -- hl: syntax highlight and code parser
  {
    "nvim-treesitter/nvim-treesitter",
    event = function()
      return "LazyFile"
    end,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
      })
    end,
  },

  -- op: automatically change tag
  {
    "windwp/nvim-ts-autotag",
    event = function()
      return {}
    end,
    ft = { "xml", "html", "javascriptreact", "typescriptreact" },
  },

  -- hl: highlight different level brackets with different color
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "LazyFile",
  },

  -- hl: highlight matched bracket
  {
    "monkoose/matchparen.nvim",
    event = "LazyFile",
    opts = {},
  },
}
