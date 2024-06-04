require("user.utils.lsp").kind_filter.lua = {
  --"Package", -- remove package since luals uses it for control flow structures
  "Module",
  "Namespace",
  "Struct",
  "Trait",
  "Enum",
  "Class",
  "Interface",
  "Constructor",
  "Field",
  "Property",
  "Method",
  "Function",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "lua", "luadoc", "luap" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    dependencies = { { "Bilal2453/luvit-meta" } },
    ft = "lua",
    opts = {
      library = {
        "luvit-meta/library",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, { name = "lazydev", group_index = 0 })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "stylua" })
    end,
  },
}
