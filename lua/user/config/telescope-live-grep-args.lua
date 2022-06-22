local M = {}

M.config = function()
  require("telescope").load_extension("live_grep_args")
  vim.api.nvim_set_keymap("n", "<C-S-F>", "<CMD>Telescope live_grep_args<CR>", { noremap = true })
end

return M
