return {
  -- Scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "User LazyFile",
    opts = {
      -- show_in_active_only = true,
      hide_if_all_visible = true,
      handle = {
        highlight = "ScrollbarHandle",
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true, -- Requires gitsigns
        search = false, -- Requires hlslens
      },
      marks = {
        Cursor = { text = "—" },
        Search = { text = { "—", "󰇼" } },
        Error = { text = { "—", "󰇼" } },
        Warn = { text = { "—", "󰇼" } },
        Info = { text = { "—", "󰇼" } },
        Hint = { text = { "—", "󰇼" } },
        Misc = { text = { "—", "󰇼" } },
        GitAdd = { text = "▎" },
        GitChange = { text = "▎" },
        GitDelete = { text = "▁" },
      },
    },
  },

  -- Git signs highlights text that has changed since the last git commit,
  -- and also lets you interactively stage & unstage hunks in a commit.
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

        -- stylua: ignore start
        map("n", "]g", gs.next_hunk, "Next Git Hunk")
        map("n", "[g", gs.prev_hunk, "Prev Git Hunk")
        map({ "o", "x" }, "ig", ":<C-u>Gitsigns select_hunk<CR>", "Select Git Hunk")
        map({ "o", "x" }, "ag", ":<C-u>Gitsigns select_hunk<CR>", "Select Git Hunk")
        map({ "n", "x" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "x" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>gd", gs.diffthis, "Diff This")
        map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff This ~")
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
      calm_down = true,
      override_lens = function(render, posList, nearest, idx, relIdx)
        local sfw = vim.v.searchforward == 1
        local indicator, text, chunks
        local absRelIdx = math.abs(relIdx)
        if absRelIdx > 1 then
          indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
        elseif absRelIdx == 1 then
          indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
        else
          indicator = ""
        end
        local lnum, col = unpack(posList[idx])
        if nearest then
          local cnt = #posList
          if indicator ~= "" then
            text = ("[%s %d/%d]"):format(indicator, idx, cnt)
          else
            text = ("[%d/%d]"):format(idx, cnt)
          end
          chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
        else
          text = ("[%s %d]"):format(indicator, idx)
          chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
        end
        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end,
    },
    cond = false,
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

  -- Active indent guide and indent text objects.
  {
    "echasnovski/mini.indentscope",
    event = "User LazyFile",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "BufTypeSpecial",
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
  },

  {
    "echasnovski/mini.animate",
    event = "User LazyFile",
    opts = function()
      -- Don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require("mini.animate")
      return {
        cursor = { enable = false },
        resize = {
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        scroll = {
          timing = animate.gen_timing.cubic({ duration = 150, unit = "total" }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          }),
        },
      }
    end,
  },

  -- Highlight word under cursor
  {
    "echasnovski/mini.cursorword",
    event = "User LazyFile",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "BufTypeSpecial",
        callback = function()
          vim.b.minicursorword_disable = true
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
    keys = { "u", "<C-r>" },
    opts = {
      -- Same as highlight on yank
      duration = 150,
      undo = { hlgroup = "Search" },
      redo = { hlgroup = "Search" },
    },
  },
}
