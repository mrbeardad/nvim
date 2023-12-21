local icons = require("user.utils.icons")

return {
  -- Language tools manager (language server, debug adapter, linter, formatter)
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    keys = { { "<Leader>pl", "<Cmd>Mason<CR>", desc = "Language Tools Manager" } },
    cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {},
  },

  -- Preset configurations for language server
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Configures lua-language-server for neovim
      { "folke/neodev.nvim", opts = {} },
      -- Load before mason.nvim and nvim-lspconfig
      "williamboman/mason.nvim",
      -- Automatically install language server when it is setup, load before nvim-lspconfig
      { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
    },
    event = "User LazyFile",
    keys = { { "<Leader>li", "<Cmd>LspInfo<CR>", desc = "Language Servers Info" } },
    opts = {
      servers = {},
      on_attach = function(client, bufnr)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
        vim.keymap.set({ "n", "x" }, "<Leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Actions" })
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.buf.inlay_hint(bufnr, true)
        end
      end,
    },
    config = function(_, opts)
      vim.fn.sign_define("DiagnosticSignError", { text = icons.diagnostics.error, texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = icons.diagnostics.warn, texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = icons.diagnostics.info, texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint", { text = icons.diagnostics.hint, texthl = "DiagnosticSignHint" })

      vim.diagnostic.config({ severity_sort = true })

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

  -- Better formating, avoid replacing entire buffer
  {
    "stevearc/conform.nvim",
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
      { "<C-_>", "gcc", remap = true, desc = "Toggle Line Comment" },
      { "<C-_>", "gc", mode = "x", remap = true, desc = "Toggle Comment" },
      { "<C-_>", "<Cmd>normal gcc<CR>", mode = "i", desc = "Toggle Comment" },
    },
    opts = {
      pre_hook = function(ctx)
        return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(ctx)
      end,
    },
  },
}
