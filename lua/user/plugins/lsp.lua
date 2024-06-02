local icons = require("user.utils.icons")

return {
  -- Language tools manager (language server, debug adapter, linter, formatter)
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    keys = { { "<Leader>lm", "<Cmd>Mason<CR>", desc = "Language Tools Manager" } },
    cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {
      ensure_installed = {},
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- Trigger FileType event to possibly load this newly installed LSP server
          vim.api.nvim_exec_autocmds("FileType", { buffer = vim.api.nvim_get_current_buf() })
        end, 100)
      end)
      local function ensure_installed()
        opts.ensure_installed = require("user.utils").tbl_unique(opts.ensure_installed)
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Preset configurations for language server
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Load before mason.nvim and nvim-lspconfig
      "williamboman/mason.nvim",
      -- Automatically install language server when it is setup, load before nvim-lspconfig
      { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
    },
    event = "User LazyFile",
    keys = { { "<Leader>li", "<Cmd>LspInfo<CR>", desc = "Language Servers Info" } },
    opts = {
      servers = {},
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          vim.keymap.set({ "n", "x" }, "<Leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Actions" })
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
      })

      -- Use these in neovim before 0.10
      vim.fn.sign_define("DiagnosticSignError", { text = icons.diagnostics.error, texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = icons.diagnostics.warn, texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = icons.diagnostics.info, texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint", { text = icons.diagnostics.hint, texthl = "DiagnosticSignHint" })

      vim.diagnostic.config({
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
          },
        },
      })

      -- Load language servers setup options in langs directory
      local lspconfig = require("lspconfig")
      for ls, lsopt in pairs(opts.servers) do
        lspconfig[ls].setup(lsopt)
      end
    end,
  },

  -- Rename like :s to preview results
  {
    "smjonas/inc-rename.nvim",
    cmd = { "IncRename" },
    keys = {
      {
        "<Leader>lr",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Rename",
      },
      { "<F2>", "<Leader>lr", remap = true, desc = "Rename" },
    },
    opts = {},
  },

  -- Linter
  {
    "mfussenegger/nvim-lint",
    event = "User LazyFile",
    opts = {
      linters_by_ft = {},
    },
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },

  -- Better formating, avoid replacing entire buffer
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      {
        "<Leader>lf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "x" },
        desc = "Format",
      },
      {
        "<Leader>lF",
        function()
          require("conform").format({ async = true, lsp_fallback = true, formatters = { "injected" } })
        end,
        mode = { "n", "x" },
        desc = "Format Injected Langs",
      },
      {
        "<A-F>",
        function()
          require("conform").format({ timeout_ms = 2000, lsp_fallback = true })
        end,
        mode = { "i", "n", "x" },
        desc = "Format",
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
  },

  -- Comments
  {
    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "<C-/>", "gcc", remap = true, desc = "which_key_ignore" },
      { "<C-_>", "gcc", remap = true, desc = "Toggle Line Comment" },
      { "<C-/>", "gc", mode = "x", remap = true, desc = "Toggle Comment" },
      { "<C-_>", "gc", mode = "x", remap = true, desc = "which_key_ignore" },
      { "<C-/>", "<Cmd>normal gcc<CR>", mode = "i", desc = "Toggle Comment" },
      { "<C-_>", "<Cmd>normal gcc<CR>", mode = "i", desc = "which_key_ignore" },
    },
    opts = {
      pre_hook = function(ctx)
        return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(ctx)
      end,
    },
  },
}
