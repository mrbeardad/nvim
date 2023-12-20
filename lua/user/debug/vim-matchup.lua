return {
  -- better matchit and matchparen
  {
    "andymass/vim-matchup",
    event = "User LazyFile",
    keys = {
      { "[[", "<Plug>(matchup-[%)", mode = { "n", "x", "o" }, desc = "Previous unmatched group" },
      { "]]", "<Plug>(matchup-]%)", mode = { "n", "x", "o" }, desc = "Next unmatched group" },
      { "ab", "<Plug>(matchup-a%)", mode = { "x", "o" }, desc = "Matched group" },
      { "ib", "<Plug>(matchup-i%)", mode = { "x", "o" }, desc = "Matched group" },
      { "dsb", "<Plug>(matchup-ds%)", mode = { "n" }, desc = "Matched group" },
      { "csb", "<Plug>(matchup-cs%)", mode = { "n" }, desc = "Matched group" },
    },
    init = function()
      vim.g.matchup_matchparen_hi_background = 1
      vim.g.matchup_matchparen_offscreen = { method = "popup", highlight = "TreesitterContext" }
      vim.g.matchup_surround_enabled = 1
    end,
  },
}
