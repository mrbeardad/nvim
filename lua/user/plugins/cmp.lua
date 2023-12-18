return {
  -- auto completion engine
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
        completion = {
          -- there are two completion styles:
          -- `noinsert` means do not automatically insert the selected item, set it if you want to confirm item by manually pressing <cr>,
          -- `noselect` means do not automatically select the first item, set it if you want to pressing <cr>
          completeopt = "menu,menuone,noinsert",
        },
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
        mapping = {
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<A-I>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.abort()
            else
              cmp.complete()
            end
          end, { "i", "c" }),
          ["<C-n>"] = cmp.mapping({
            i = function()
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.complete()
              end
            end,
            c = function()
              if cmp.visible() then
                cmp.select_next_item()
              else
                cmp.complete()
              end
            end,
          }),
          ["<C-p>"] = cmp.mapping({
            i = function()
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.complete()
              end
            end,
            c = function()
              if cmp.visible() then
                cmp.select_prev_item()
              else
                cmp.complete()
              end
            end,
          }),
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
            if not require("cmp").confirm() then
              fallback() -- fallback to autopairs
            end
          end, { "i", "c" }),
          ["<S-CR>"] = cmp.mapping(function(fallback)
            vim.cmd("let &ul=&ul") -- break undo
            if not require("cmp").confirm({ behavior = cmp.ConfirmBehavior.Replace }) then
              fallback()
            end
          end, { "i", "c" }),
          ["<C-CR>"] = cmp.mapping(function(fallback)
            vim.cmd("let &ul=&ul") -- break undo
            cmp.abort()
            fallback()
          end, { "i", "c" }),
        },
        formatting = {
          -- TODO: icons
          --format = function(_, item)
          --  local icons = require("lazyvim.config").icons.kinds
          --  if icons[item.kind] then
          --    item.kind = icons[item.kind] .. item.kind
          --  end
          --  return item
          --end,
        },
        experimental = {
          ghost_text = {
            hl_group = "Comment",
          },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      -- basic setup
      cmp.setup(opts)

      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        completion = {
          -- do not automatically select the first item in cmdline since <cr> has special effect in cmdline
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

      -- history search
      -- vim.keymap.set("c", "<C-n>", "<Down>", { desc = "History Forward Search" })
      -- vim.keymap.set("c", "<C-p>", "<Up>", { desc = "History Backward Search" })
    end,
  },

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    build = not jit.os:find("Windows") and "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    event = "InsertEnter",
    keys = {
      -- do not use <tab> to expand snippets since it could conflict between jumps and expands,
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
      -- when to check if the current snippet was deleted
      delete_check_events = "TextChanged",
    },
  },

  -- auto pairs
  {
    "windwp/nvim-autopairs",
    dependencies = { "hrsh7th/nvim-cmp" },
    event = "InsertEnter",
    keys = {
      { "<C-CR>", "<CR>", mode = "i", remap = true, desc = "Autopairs" },
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
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      -- insert `(` after select function or method item
      require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },
}
