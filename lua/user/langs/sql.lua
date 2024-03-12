return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "sql" })
    end,
  },

  -- require cgo
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       sqls = {},
  --     },
  --   },
  -- },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sql = { "sqlfluff" },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sqlfluff" },
      },
      formatters = {
        sqlfluff = {
          command = "sqlfluff",
          args = {
            "format",
            "--nocolor",
            "--dialect",
            "ansi",
            "--disable-progress-bar",
            "-",
          },
          stdin = true,
        },
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "sqlfluff" })
    end,
  },
}
