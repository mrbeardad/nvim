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
        map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", "Select Git Hunk")
        map({ "o", "x" }, "ag", ":<C-U>Gitsigns select_hunk<CR>", "Select Git Hunk")
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
    opts = {
      calm_down = false, -- enable this if you want to execute :nohl automatically
      enable_incsearch = false,
      override_lens = function(render, posList, nearest, idx, _)
        --                           🠇 This is \u00A0 since ascii space will disappear in vscode
        local text = nearest and ("%s [%d/%d]"):format(vim.fn.getreg("/"), idx, #posList) or ""
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
          if vim.bo[ev.buf].filetype ~= "noice" and not utils.is_real_file(ev.buf) then
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
    "RRethy/vim-illuminate",
    event = "User LazyFile",
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
    opts = {
      delay = 300,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
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
      { "<C-R>", desc = "Redo" },
      { "<C-Z>", "<Cmd>normal u<CR>", mode = "i", desc = "Undo" },
    },
    opts = {
      -- Same as highlight on yank
      duration = 150,
      undo = { hlgroup = "Search" },
      redo = { hlgroup = "Search", lhs = "U" },
    },
  },
}
