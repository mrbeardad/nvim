return {
  {
    "stevearc/conform.nvim",
    keys = {
      { "<leader>cF", false, mode = { "n", "v" } },
      {
        "<Leader>lF",
        function()
          require("conform").format({ formatters = { "injected" } })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
  },
}
