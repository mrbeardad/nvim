local utils = require("user.utils")

return {
  -- Auto completion engine
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      return {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        performance = { fetching_timeout = 150 },
        completion = {
          -- There are two completion styles:
          -- `noinsert` means do not automatically insert the selected item, set it if you want to confirm item by manually pressing <cr>,
          -- `noselect` means do not automatically select the first item, set it if you want to pressing <cr>
          completeopt = "menu,menuone,noinsert",
        },
        mapping = {
          ["<C-F>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-B>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-N>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            else
              cmp.complete()
            end
          end, { "i" }),
          ["<C-P>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            else
              cmp.complete()
            end
          end, { "i" }),
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
          ["<CR>"] = cmp.mapping({
            i = function(fallback)
              vim.cmd("let &ul=&ul") -- break undo
              if not require("cmp").confirm() then
                fallback()
              end
            end,
            c = function(fallback)
              if not require("cmp").confirm() then
                fallback()
              end
            end,
          }),
          ["<S-CR>"] = cmp.mapping({
            i = function(fallback)
              vim.cmd("let &ul=&ul")
              if not require("cmp").confirm({ behavior = cmp.ConfirmBehavior.Replace }) then
                fallback()
              end
            end,
            c = function(fallback)
              if not require("cmp").confirm({ behavior = cmp.ConfirmBehavior.Replace }) then
                fallback()
              end
            end,
          }),
          ["<C-CR>"] = cmp.mapping({
            i = function(fallback)
              vim.cmd("let &ul=&ul")
              cmp.abort()
              fallback()
            end,
            c = function(fallback)
              cmp.abort()
              fallback()
            end,
          }),
        },
        formatting = {
          format = function(_, item)
            local icons = require("user.utils.icons").kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      -- Basic setup
      cmp.setup(opts)

      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        completion = {
          -- Do not automatically select the first item in cmdline since <cr> has special effect in cmdline
          completeopt = "menu,menuone,noselect",
        },
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      -- `/` and `?` cmdline setup.
      cmp.setup.cmdline({ "/", "?" }, {
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        sources = {
          { name = "buffer" },
        },
      })

      -- History search
      -- vim.keymap.set("c", "<C-N>", "<Down>", { desc = "History Forward Search" })
      -- vim.keymap.set("c", "<C-P>", "<Up>", { desc = "History Backward Search" })
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    build = not utils.is_windows() and "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    event = "InsertEnter",
    keys = {
      -- Do not use <tab> to expand snippets since it could conflict between jumps and expands,
      -- just expand snippets by pressing <cr> in completion menu
      {
        "<Tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<Tab>",
        function()
          require("luasnip").jump(1)
        end,
        mode = "s",
      },
      {
        "<S-Tab>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
      },
    },
    opts = {
      -- When to check if the current snippet was deleted
      delete_check_events = "TextChanged",
    },
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    dependencies = { "hrsh7th/nvim-cmp" },
    event = "InsertEnter",
    keys = {
      {
        "<A-p>",
        function()
          local state = require("nvim-autopairs").state
          state.disabled = not state.disabled
        end,
        mode = "i",
        desc = "Toggle Autopairs",
      },
    },
    opts = {
      fast_wrap = {},
    },
    config = function()
      require("nvim-autopairs").setup({})
      -- If you want insert `(` after select function or method item
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
