local M = {}

M.config = function()
	-- automatically change dark/light theme
	table.insert(lvim.plugins, {
		"vimpostor/vim-lumen",
		dependencies = { "folke/tokyonight.nvim" },
		priority = 1000,
	})

	lvim.colorscheme = "tokyonight"
	lvim.builtin.theme.name = "tokyonight"
	lvim.builtin.theme.tokyonight.options.style = "storm"
	lvim.builtin.theme.tokyonight.options.dim_inactive = true
	lvim.builtin.theme.tokyonight.options.on_highlights = function(hl, c)
		-- set the dark theme colors, and tokyonight will invert the colors for light theme automatically
		local lighten = require("tokyonight.util").lighten
		local darken = require("tokyonight.util").darken
		hl.ScrollbarHandle = {
			bg = lighten(hl.ScrollbarHandle.bg, 0.9),
		}
		hl.FlashLabel = {
			fg = lighten(hl.FlashLabel.fg, 0.1),
			bg = hl.FlashLabel.bg,
			bold = true,
			italic = true,
		}
		hl.FlashLabelUnselected = {
			fg = darken(hl.FlashLabel.fg, 0.8),
			bg = darken(hl.FlashLabel.bg, 0.8),
			bold = true,
			italic = true,
		}
		hl.MatchParen = {
			fg = hl.MatchParen.fg,
			bg = hl.IlluminatedWordText.bg,
			bold = true,
			italic = true,
		}
	end
end

return M
