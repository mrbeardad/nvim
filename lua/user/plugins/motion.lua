local keymap = require("user.utils.keymap")
local utils = require("user.utils")

return {
  -- Parse code to AST, and use it to highlight, move, select, etc.
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
          local configs = require("nvim-treesitter.configs")
          for name, fn in pairs(move) do
            if name:find("goto") == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                  for key, query in pairs(config or {}) do
                    if q == query and key:find("[%]%[][cC]") then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
    },
    build = ":TSUpdate",
    event = "User LazyFile",
    cmd = { "TSInstall", "TSUpdate", "TSUpdateSync" },
    opts = {
      ensure_installed = {
        "c",
        "bash",
        "lua",
        "vim",
        "vimdoc",
        "query",
        -- Ensure to install all the parser above
        "regex",
        "diff",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
      },
      highlight = { enable = true },
      indent = { enable = true },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]a"] = "@parameter.outer", ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]A"] = "@parameter.outer", ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[a"] = "@parameter.outer", ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[A"] = "@parameter.outer", ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    },
    config = function(plugin, opts)
      -- Duplicate parser will cause problem
      opts.ensure_installed = utils.tbl_unique(opts.ensure_installed)

      -- Add nvim-treesitter queries to the rtp and its custom query predicates early.
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`,
      -- which no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries,
      -- which we make available during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Show flag around target positions and choose them to jump
  {
    "folke/flash.nvim",
    event = "CmdlineEnter",
    -- stylua: ignore
    keys = {
      { "f", mode = { "n", "x", "o" } },
      { "F", mode = { "n", "x", "o" } },
      { "t", mode = { "n", "x", "o" } },
      { "T", mode = { "n", "x", "o" } },
      { "r", "<Cmd>lua require('flash').remote({restore=true})<CR>", mode = "o", desc = "Flash Remote" },
      { "S", "<Cmd>lua require('flash').treesitter()<CR>", mode = { "n", "o", "x" }, desc = "Flash Treesitter" },
      { ";", "<Cmd>lua require('flash').treesitter({jump={pos='start'}})<CR>", mode = { "n", "o", "x" }, desc = "Outter Start Of Treesitter Node" },
      { ",", "<Cmd>lua require('flash').treesitter({jump={pos='end'}})<CR>", mode = { "n", "o", "x" }, desc = "Outter Start Of Treesitter Node" },
    },
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm1234567890",
      label = {
        after = false,
        before = true,
      },
      modes = {
        char = {
          highlight = { backdrop = false },
          -- Exclude some motion and operator
          label = { exclude = "ryipasdhjklxcvYPSDJKXCV" },
          keys = { "f", "F", "t", "T" },
          jump_labels = true,
          autohide = true,
          char_actions = function(motion)
            return {
              [";"] = "next",
              [","] = "prev",
              [motion:lower()] = "right",
              [motion:upper()] = "left",
            }
          end,
        },
        treesitter = {
          -- Extra exclude `o`
          label = { exclude = "ryiopasdhjklxcvYPSDJKXCV" },
        },
      },
    },
  },
  -- Flash Telescope config
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-S>"] = keymap.flash_telescope,
          },
        },
      },
    },
  },

  -- Better text-objects
  {
    "echasnovski/mini.ai",
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
      { "g[", mode = { "n", "x", "o" } },
      { "g]", mode = { "n", "x", "o" } },
    },
    init = function()
      -- Register all text objects with which-key
      utils.on_load("which-key.nvim", function()
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
    opts = function()
      local ai = require("mini.ai")
      return {
        mappings = {
          around_last = "aN",
          inside_last = "iN",
        },
        n_lines = 250,
        custom_textobjects = {
          -- Line
          l = { "^()%s*().*()%s*()\n$" },
          -- Entire buffer
          e = function()
            return {
              from = { line = 1, col = 1 },
              ---@diagnostic disable-next-line
              to = { line = vim.fn.line("$"), col = math.max(vim.fn.getline("$"):len(), 1) },
            }
          end,
          -- a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }, {}),
          F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
        },
      }
    end,
  },
}
