local utils = require("user.utils")

return {
  -- Highlights text that `git diff` shows, and stage & unstage hunks interactively.
  {
    "lewis6991/gitsigns.nvim",
    event = "User LazyFile",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      current_line_blame = true,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        local function goto_hunk(next)
          return function()
            if vim.wo.diff then
              vim.cmd("normal! " .. (next and "]c" or "[c"))
            else
              require("gitsigns")[next and "next_hunk" or "prev_hunk"]()
            end
          end
        end

        -- stylua: ignore start
        map("n", "]g", goto_hunk(true), "Next Git Hunk")
        map("n", "[g", goto_hunk(false), "Prev Git Hunk")
        map({ "o", "x" }, "ig", ":<C-u>Gitsigns select_hunk<CR>", "Select Git Hunk")
        map({ "o", "x" }, "ag", ":<C-u>Gitsigns select_hunk<CR>", "Select Git Hunk")
        map({ "n", "x" }, "<Leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "x" }, "<Leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<Leader>gS", gs.stage_buffer, "Stage Buffer")
        map("n", "<Leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<Leader>gR", gs.reset_buffer, "Reset Buffer")
        map("n", "<Leader>gp", gs.preview_hunk, "Preview Hunk")
        map("n", "<Leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<Leader>gd", gs.diffthis, "Diff This")
        map("n", "<Leader>gD", function() gs.diffthis("~") end, "Diff This ~")
      end,
    },
  },

  -- Display search info after match results
  {
    "kevinhwang91/nvim-hlslens",
    -- only use it in vscode, in neovim, use noice instead
    lazy = true,
    opts = {
      calm_down = true,
      override_lens = function(render, posList, nearest, idx, _)
        local text = nearest and ("[%d/%d]"):format(idx, #posList) or ""
        local chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
        local lnum, col = unpack(posList[idx])
        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end,
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "User LazyFile",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {},
    },
  },

  -- Indent guides animation
  {
    "echasnovski/mini.indentscope",
    event = "User LazyFile",
    init = function()
      -- Disable in special buffer
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          if utils.is_real_file(ev.buf) then
            vim.api.nvim_buf_set_var(ev.buf, "miniindentscope_disable", true)
          end
        end,
      })
    end,
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
  },

  -- Highlight the word under cursor
  {
    "echasnovski/mini.cursorword",
    event = "User LazyFile",
    init = function()
      -- Disable in special buffer
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          if utils.is_real_file(ev.buf) then
            vim.api.nvim_buf_set_var(ev.buf, "minicursorword_disable", true)
          end
        end,
      })
    end,
    opts = {
      delay = vim.o.timeoutlen,
    },
  },

  -- Highlight different level brackets with different color
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "User LazyFile",
  },

  -- Highlight matched bracket
  {
    "monkoose/matchparen.nvim",
    event = "User LazyFile",
    opts = {},
  },

  -- Highlight undo/redo change
  {
    "tzachar/highlight-undo.nvim",
    keys = {
      { "u", desc = "Undo" },
      { "<C-r>", desc = "Redo" },
      { "<C-z>", "<Cmd>normal u<CR>", mode = "i", desc = "Undo" },
    },
    opts = {
      -- Same as highlight on yank
      duration = 150,
      undo = { hlgroup = "Search" },
      redo = { hlgroup = "Search" },
    },
  },
}
