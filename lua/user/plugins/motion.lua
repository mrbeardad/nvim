local utils = require("user.utils")
local flash_utils = require("user.utils.flash")

return {
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require("nvim-treesitter.textobjects.move")
          local configs = require("nvim-treesitter.configs")
          for name, fn in pairs(move) do
            if name:find("goto") == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name]
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
      incremental_selection = {
        -- Use flash treeitter instead
        enable = false,
      },
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

  -- Show flag around positions and choose them to jump
  {
    "folke/flash.nvim",
    event = "CmdlineEnter",
    keys = {
      { "f", mode = { "n", "x", "o" } },
      { "F", mode = { "n", "x", "o" } },
      { "t", mode = { "n", "x", "o" } },
      { "T", mode = { "n", "x", "o" } },
      -- { ";", mode = { "n", "x", "o" } },
      -- { ",", mode = { "n", "x", "o" } },
      { "r", "<Cmd>lua require('flash').remote({restore=true})<CR>", mode = "o", desc = "Flash Remote" },
      { "S", "<Cmd>lua require('flash').treesitter()<CR>", mode = { "n", "o", "x" }, desc = "Flash Treesitter" },
      {
        ";",
        "<Cmd>lua require('flash').treesitter({jump={pos='start'}})<CR>",
        mode = { "n", "o", "x" },
        desc = "Outter Start Of Treesitter Node",
      },
      {
        ",",
        "<Cmd>lua require('flash').treesitter({jump={pos='end'}})<CR>",
        mode = { "n", "o", "x" },
        desc = "Outter Start Of Treesitter Node",
      },
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
            ["<C-s>"] = flash_utils.flash_telescope,
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
    opts = function()
      local ai = require("mini.ai")
      return {
        mappings = {
          around_last = "ap",
          inside_last = "ip",
        },
        n_lines = 1000,
        custom_textobjects = {
          a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          -- Entire buffer
          e = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
      }
    end,
    init = function()
      -- Register all text objects with which-key
      utils.on_load("which-key.nvim", function()
        local i = {
          [" "] = "Whitespace",
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
          _ = "Underscore",
          a = "Argument",
          b = "Balanced ), ], }",
          c = "Class",
          f = "Function",
          o = "Block/Conditional/loop",
          q = "Quote `, \", '",
          t = "Tag",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = v:gsub(" including.*", "")
        end

        local ic = vim.deepcopy(i)
        local ac = vim.deepcopy(a)
        for key, name in pairs({ n = "Next", l = "Last" }) do
          i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
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

  -- Modify surround bracket, quote and others
  {
    "kylechui/nvim-surround",
    keys = {
      { "ds", mode = "n" },
      { "cs", mode = "n" },
      { "cS", mode = "n" },
      { "ys", mode = "n" },
      { "yss", mode = "n" },
      { "yS", mode = "n" },
      { "ySS", mode = "n" },
      { "gs", mode = "x" },
      { "gS", mode = "x" },
      { "<C-g>s", mode = "i" },
      { "<C-g>S", mode = "i" },
    },
    opts = {
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "gs",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
    },
  },
}
