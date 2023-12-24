return {
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

  {
    "windwp/nvim-ts-autotag",
    event = function()
      return {}
    end,
    ft = { "xml", "html", "javascriptreact", "typescriptreact" },
  },

  -- Highlight different level brackets with different color
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "LazyFile",
  },

  -- Highlight matched bracket
  {
    "monkoose/matchparen.nvim",
    event = "LazyFile",
    opts = {},
  },
}
