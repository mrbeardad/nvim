local M = {}

local keymap = require("user.which-key").keymap

local function goto_change(next)
	return function()
		if vim.wo.diff then
			return next and "]c" or "[c"
		end
		vim.schedule(function()
			require("gitsigns")[next and "next_hunk" or "prev_hunk"]()
		end)
		return "<Ignore>"
	end
end

M.config = function()
	table.insert(lvim.plugins, {
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "Trouble", "TroubleClose", "TroubleToggle" },
		opts = {
			use_diagnostic_signs = true,
		},
		cond = not vim.g.vscode,
	})

	if vim.g.vscode then
		local vscode = require("vscode-neovim")
		keymap({ "n" }, "gt", function()
			vscode.action("editor.action.goToTypeDefinition")
		end)
		keymap({ "n" }, "gr", function()
			vscode.action("editor.action.goToReferences")
		end)
		keymap({ "n" }, "gi", function()
			vscode.action("editor.action.goToImplementation")
		end)
		keymap("n", "]e", function()
			vscode.action("editor.action.marker.next")
		end)
		keymap("n", "[e", function()
			vscode.action("editor.action.marker.prev")
		end)
		keymap("n", "]c", function()
			vscode.action("workbench.action.editor.nextChange")
			vscode.action("workbench.action.compareEditor.nextChange")
		end)
		keymap("n", "[c", function()
			vscode.action("workbench.action.editor.previousChange")
			vscode.action("workbench.action.compareEditor.previousChange")
		end)
	else
		lvim.lsp.buffer_mappings.normal_mode["gd"] = nil
		lvim.lsp.buffer_mappings.normal_mode["gr"] = nil
		keymap("n", "gd", "<Cmd>Trouble lsp_definitions<CR>", { desc = "Go to definitions" })
		keymap("n", "gt", "<Cmd>Trouble lsp_type_definitions<CR>", { desc = "Go to type definitions" })
		keymap("n", "gr", "<Cmd>Trouble lsp_references<CR>", { desc = "Go to references" })
		keymap("n", "gi", "<Cmd>Trouble lsp_implementations<CR>", { desc = "Go to implementations" })

		keymap("n", "<C-S-M>", "<Cmd>TroubleToggle workspace_diagnostics<CR>")
		keymap("n", "[e", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Previous diagnostic" })
		keymap("n", "]e", "<Cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })

		lvim.builtin.gitsigns.opts.current_line_blame = true
		lvim.builtin.gitsigns.opts.on_attach = function(bufnr)
			keymap("n", "]c", goto_change(true), { expr = true, bufnr = bufnr, desc = "Next change" }, true)
			keymap("n", "[c", goto_change(), { expr = true, bufnr = bufnr, desc = "Previous change" }, true)
		end
	end
end

return M
