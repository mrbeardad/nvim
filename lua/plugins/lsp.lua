return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "gI", false }
      keys[#keys + 1] = {
        "gi",
        function()
          require("telescope.builtin").lsp_implementations({ reuse_win = true })
        end,
        desc = "Goto Implementation",
      }
      keys[#keys + 1] = { "gy", false }
      keys[#keys + 1] = {
        "gt",
        function()
          require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
        end,
        desc = "Goto Type Definition",
      }
      keys[#keys + 1] = { "<c-k>", mode = "i", false }
      keys[#keys + 1] = { "<F2>", "<leader>cr", remap = true, desc = "Rename" }
    end,
    opts = {
      inlay_hints = {
        enabled = true,
      },
    },
  },

  {
    "smjonas/inc-rename.nvim",
    cmd = { "IncRename" },
    opts = {},
  },
}
