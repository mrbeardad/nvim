if not vim.g.vscode then
  return {}
end

local enabled = {
  "lazy.nvim",
  "nvim-hlslens",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "flash.nvim",
  "mini.ai",
  "mini.surround",
  "yanky.nvim",
}

local lazy_config = require("lazy.core.config")
lazy_config.options.checker.enabled = false
lazy_config.options.change_detection.enabled = false
lazy_config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name)
end

return {
  {
    "kevinhwang91/nvim-hlslens",
    event = "CmdlineEnter",
    keys = {
      {
        "n",
        [[<Cmd>execute("normal! " . v:count1 . "Nn"[v:searchforward])<CR><Cmd>lua require("hlslens").start()<CR>]],
        mode = { "n", "x" },
        desc = "Repeat last search in forward direction",
      },
      {
        "N",
        [[<Cmd>execute("normal! " . v:count1 . "nN"[v:searchforward])<CR><Cmd>lua require("hlslens").start()<CR>]],
        mode = { "n", "x" },
        desc = "Repeat last search in backward direction",
      },
      {
        "*",
        [[*<Cmd>lua require("hlslens").start()<CR>]],
        desc = "Search forward for nearest word (match word)",
      },
      {
        "#",
        [[#<Cmd>lua require("hlslens").start()<CR>]],
        desc = "Search forward for nearest word (match word)",
      },
      {
        "g*",
        [[g*<Cmd>lua require("hlslens").start()<CR>]],
        mode = { "n", "x" },
        desc = "Search forward for nearest word",
      },
      {
        "g#",
        [[g#<Cmd>lua require("hlslens").start()<CR>]],
        mode = { "n", "x" },
        desc = "Search backward for nearest word",
      },
    },
    config = function(_, opts)
      require("hlslens").setup(opts)
      -- To clear and redraw in vscode
      -- require("hlslens.lib.event"):on("LensUpdated", function()
      --   vim.cmd.mode()
      -- end, {})
      -- TODO: colorscheme
      -- vim.cmd("hi HlSearchLensNear guibg=#40bf6a guifg=#062e32")
      -- vim.cmd("hi HlSearchLens guibg=#0a5e69 guifg=#b2cac3")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = { enable = false },
      indent = { enable = false },
    },
  },
}
