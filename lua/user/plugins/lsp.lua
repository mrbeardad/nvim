return {
  -- language tools manager (language server, debug adapter, linter, formatter)
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    keys = { { "<Leader>pl", "<Cmd>Mason<CR>", desc = "Language Tools Manager" } },
    cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {},
  },

  -- preset configurations for language server
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- configures lua-language-server for neovim
      { "folke/neodev.nvim", opts = {} },
      -- load before mason.nvim and nvim-lspconfig
      "williamboman/mason.nvim",
      -- PERF: disabled on startup
      -- automatically install language server when it is setup, load before nvim-lspconfig
      { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
    },
    event = "BufReadPost",
    keys = { { "<Leader>li", "<Cmd>LspInfo<CR>", desc = "Language Servers Info" } },
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- buffer local mappings.
          -- see `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          -- use telescope instead
          -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          -- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
          -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "x" }, "<Leader>la", vim.lsp.buf.code_action, opts)
        end,
      })
      vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError", numhl = "" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn", numhl = "" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo", numhl = "" })
      vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint", numhl = "" })
    end,
    opts = { servers = {} },
    -- load language servers setup options in langs directory
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for ls, lsopt in pairs(opts.servers) do
        lspconfig[ls].setup(lsopt)
      end
    end,
  },

  -- better formating
  {
    "stevearc/conform.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "BufWritePre",
    keys = {
      {
        "<Leader>lF",
        function()
          require("conform").format({ async = true, lsp_fallback = true, formatters = { "injected" } })
        end,
        mode = { "n", "x" },
        desc = "Format Injected Langs",
      },
      {
        "<Leader>lf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "x" },
        desc = "Format",
      },
      {
        "<A-F>",
        function()
          require("conform").format({ timeout_ms = 2000, lsp_fallback = true })
        end,
        mode = { "i", "n", "x" },
        desc = "Format",
      },
      {
        "<Leader>lI",
        "<Cmd>ConformInfo<CR>",
        desc = "Formatter Info",
      },
    },
    init = function()
      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 2000,
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
    -- TODO: install at startup by command
    -- automatically install enabled formatters
    config = function(_, opts)
      local conform = require("conform")
      conform.setup(opts)
      local formatters = {}
      for _, fmt in ipairs(conform.list_all_formatters()) do
        if not fmt.available then
          table.insert(formatters, fmt.name)
        end
      end
      if #formatters > 0 then
        require("user.utils").ensure_install_tools(formatters)
      end
    end,
  },

  -- Fast and feature-rich surround actions. For text that includes
  -- surrounding characters like brackets or quotes, this allows you
  -- to select the text inside, change or modify the surrounding characters,
  -- and more.
  -- {
  --   "echasnovski/mini.surround",
  --   keys = function(_, keys)
  --     -- Populate the keys based on the user's options
  --     local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
  --     local opts = require("lazy.core.plugin").values(plugin, "opts", false)
  --     local mappings = {
  --       { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
  --       { opts.mappings.delete, desc = "Delete surrounding" },
  --       { opts.mappings.find, desc = "Find right surrounding" },
  --       { opts.mappings.find_left, desc = "Find left surrounding" },
  --       { opts.mappings.highlight, desc = "Highlight surrounding" },
  --       { opts.mappings.replace, desc = "Replace surrounding" },
  --       { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
  --     }
  --     mappings = vim.tbl_filter(function(m)
  --       return m[1] and #m[1] > 0
  --     end, mappings)
  --     return vim.list_extend(mappings, keys)
  --   end,
  --   opts = {
  --     mappings = {
  --       add = "gsa", -- Add surrounding in Normal and Visual modes
  --       delete = "gsd", -- Delete surrounding
  --       find = "gsf", -- Find surrounding (to the right)
  --       find_left = "gsF", -- Find surrounding (to the left)
  --       highlight = "gsh", -- Highlight surrounding
  --       replace = "gsr", -- Replace surrounding
  --       update_n_lines = "gsn", -- Update `n_lines`
  --     },
  --   },
  -- },

  -- comments
  --{
  --  "JoosepAlviste/nvim-ts-context-commentstring",
  --  lazy = true,
  --  opts = {
  --    enable_autocmd = false,
  --  },
  --},
  --{
  --  "echasnovski/mini.comment",
  --  event = "VeryLazy",
  --  opts = {
  --    options = {
  --      custom_commentstring = function()
  --        return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
  --      end,
  --    },
  --  },
  --},
}
