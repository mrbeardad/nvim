return {
  -- scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "User LazyFile",
    opts = {
      --show_in_active_only = true,
      hide_if_all_visible = true,
      handle = {
        highlight = "ScrollbarHandle",
      },
      handlers = {
        cursor = false,
        diagnostic = true,
        gitsigns = true, -- Requires gitsigns
        search = false, -- Requires hlslens
      },
      marks = {
        Search = { text = { "—", "󰇼" } },
        Error = { text = { "—", "󰇼" } },
        Warn = { text = { "—", "󰇼" } },
        Info = { text = { "—", "󰇼" } },
        Hint = { text = { "—", "󰇼" } },
        Misc = { text = { "—", "󰇼" } },
        -- GitAdd = { text = "▐" },
        -- GitChange = { text = "▐" },
        GitDelete = { text = "▁" },
      },
    },
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
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

        local function goto_change(next)
          return function()
            if vim.wo.diff then
              vim.cmd("normal! " .. (next and "]c" or "[c"))
            else
              vim.schedule(function()
                require("gitsigns")[next and "next_hunk" or "prev_hunk"]()
              end)
            end
          end
        end

        -- stylua: ignore start
        map("n", "]c", goto_change(true), "Next Change")
        map("n", "[c", goto_change(), "Prev Change")
        map({ "o", "x" }, "ic", ":<C-u>Gitsigns select_hunk<CR>", "Select Change Hunk")
        map({ "o", "x" }, "ac", ":<C-u>Gitsigns select_hunk<CR>", "Select Change Hunk")
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

  -- show search info
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

  -- indent guides for Neovim
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

  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    event = "User LazyFdile",
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
    event = "VeryLazy",
    init = function()
      vim.api.nvim_create_autocmd("SessionLoadPost", {
        callback = function()
          vim.g.minianimate_disable = false
        end,
      })
      vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function()
          vim.g.minianimate_disable = true
        end,
      })
      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          vim.g.minianimate_disable = false
        end,
      })
    end,
    opts = function()
      -- don't use anima=te when scrolling with the mouse
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

  -- highlight word under cursor
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

  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "User LazyFile",
    cmd = { "TSInstall", "TSUpdate", "TSUpdateSync" },
    opts = {
      ensure_installed = {
        "c",
        "lua",
        "luadoc",
        "luap",
        "vim",
        "vimdoc",
        "query",
        "diff",
        "regex",
        "comment",
        "markdown_inline",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(plugin, opts)
      -- add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "User LazyFile",
  },
}
