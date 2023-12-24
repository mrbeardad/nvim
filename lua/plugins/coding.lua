return {
  -- cmp: auto completion engine
  {
    "hrsh7th/nvim-cmp",
    event = { "CmdlineEnter" },
    dependencies = { "hrsh7th/cmp-cmdline" },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = {
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<A-I>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.abort()
          else
            cmp.complete()
          end
        end, { "i", "c" }),
        ["<C-n>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end, { "i", "c" }),
        ["<C-p>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end, { "i", "c" }),
        ["<Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end, { "c" }),
        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end, { "c" }),
        ["<CR>"] = cmp.mapping(function(fallback)
          vim.cmd("let &ul=&ul") -- break undo
          if cmp.visible() then
            cmp.confirm()
          else
            fallback()
          end
        end, { "i", "c" }),
        ["<S-CR>"] = cmp.mapping(function(fallback)
          vim.cmd("let &ul=&ul") -- break undo
          if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace })
          else
            fallback()
          end
        end, { "i", "c" }),
        ["<C-CR>"] = cmp.mapping(function(fallback)
          vim.cmd("let &ul=&ul") -- break undo
          cmp.abort()
          fallback()
        end, { "i", "c" }),
      }
      require("lazyvim.util").on_load("nvim-cmp", function()
        -- `:` cmdline setup
        cmp.setup.cmdline(":", {
          completion = { completeopt = "menu,menuone,noselect" },
          sources = cmp.config.sources({
            { name = "path" },
          }, {
            { name = "cmdline" },
          }),
        })

        -- `/` and `?` cmdline setup
        cmp.setup.cmdline({ "/", "?" }, {
          completion = { completeopt = "menu,menuone,noselect" },
          sources = {
            { name = "buffer" },
          },
        })
      end)
    end,
  },

  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    keys = {
      { "<C-CR>", "<CR>", mode = "i", remap = true, desc = "Autopairs" },
      {
        "<Leader>up",
        function()
          local Util = require("lazy.core.util")
          local state = require("nvim-autopairs").state
          state.disabled = not state.disabled
          if state.disabled then
            Util.warn("Disabled auto pairs", { title = "Option" })
          else
            Util.info("Enabled auto pairs", { title = "Option" })
          end
        end,
        desc = "Toggle auto pairs",
      },
      { "<A-p>", '<Cmd>lua vim.cmd.normal(vim.g.mapleader.."up")<CR>', mode = "i", desc = "Toggle Autopairs" },
    },
    opts = {
      fast_wrap = {},
    },
  },

  {
    "echasnovski/mini.surround",
    keys = {
      { "s", ":<C-u>lua MiniSurround.add('visual')<CR>", mode = "x", desc = "Add Surround" },
    },
    opts = function(_, opts)
      opts.mappings = {
        add = "ys", -- Add surrounding in Normal and Visual modes
        replace = "cs", -- Replace surrounding
        delete = "ds", -- Delete surrounding
        find = "", -- Find surrounding (to the right)
        find_left = "", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        update_n_lines = "", -- Update `n_lines`
      }
      require("lazyvim.util").on_load("mini.surround", function()
        vim.keymap.del("x", "ys")
      end)
    end,
  },

  {
    "echasnovski/mini.comment",
    enabled = false,
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "<C-/>", "gcc", remap = true, desc = "which_key_ignore" },
      { "<C-_>", "gcc", remap = true, desc = "Toggle Line Comment" },
      { "<C-/>", "gc", mode = "x", remap = true, desc = "Toggle Comment" },
      { "<C-_>", "gc", mode = "x", remap = true, desc = "which_key_ignore" },
      { "<C-/>", "<Cmd>normal gcc<CR>", mode = "i", desc = "Toggle Comment" },
      { "<C-_>", "<Cmd>normal gcc<CR>", mode = "i", desc = "which_key_ignore" },
    },
    opts = {
      pre_hook = function(ctx)
        return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(ctx)
      end,
    },
  },

  {
    "echasnovski/mini.ai",
    event = function()
      return {}
    end,
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
      { "g[", mode = { "n", "x", "o" } },
      { "g]", mode = { "n", "x", "o" } },
    },
    opts = function(_, opts)
      opts.mappings = {
        around_last = "aN",
        inside_last = "iN",
      }
      -- line
      opts.custom_textobjects.l = { "^.*$", "^%s*().*()%s*$" }
      -- entire buffer
      opts.custom_textobjects.e = function()
        return {
          from = { line = 1, col = 1 },
          ---@diagnostic disable-next-line
          to = { line = vim.fn.line("$"), col = math.max(vim.fn.getline("$"):len(), 1) },
        }
      end
      -- function
      opts.custom_textobjects.F = opts.custom_textobjects.f
      -- function call
      opts.custom_textobjects.f = nil
      -- a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }, {}),
    end,
    init = function()
      -- Register all text objects with which-key
      require("lazyvim.util").on_load("which-key.nvim", function()
        local i = {
          ['"'] = 'Balanced "',
          ["'"] = "Balanced '",
          ["`"] = "Balanced `",
          ["("] = "Balanced (",
          [")"] = "Balanced ) including white-space",
          [">"] = "Balanced > including white-space",
          ["<lt>"] = "Balanced <",
          ["]"] = "Balanced ] including white-space",
          ["["] = "Balanced [",
          ["}"] = "Balanced } including white-space",
          ["{"] = "Balanced {",
          ["?"] = "User Prompt",
          q = "Quote `, \", '",
          b = "Balanced ), ], }",
          t = "Tag",
          l = "Line",
          e = "Entire Buffer",
          a = "Argument",
          f = "Function Call",
          F = "Function",
          c = "Class",
          o = "Block/Conditional/loop",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = v:gsub(" including.*", "")
        end

        local ic = vim.deepcopy(i)
        local ac = vim.deepcopy(a)
        for key, name in pairs({ n = "Next", N = "Previous" }) do
          ---@diagnostic disable-next-line
          i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
          ---@diagnostic disable-next-line
          a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
        end
        require("which-key").register({
          mode = { "o", "x" },
          i = i,
          a = a,
        })
      end)
    end,
  },
}
