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
      { "f", mode = { "n", "x" } },
      { "F", mode = { "n", "x" } },
      { "t", mode = { "n", "x" } },
      { "T", mode = { "n", "x" } },
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
          jump = { autojump = true },
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
    config = function(plugin, opts)
      require("flash").setup(opts)
      vim.keymap.del({ "o" }, "f", {})
      vim.keymap.del({ "o" }, "F", {})
      vim.keymap.del({ "o" }, "t", {})
      vim.keymap.del({ "o" }, "T", {})
    end,
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
        local objects = {
          { " ", desc = "whitespace" },
          { '"', desc = '" string' },
          { "'", desc = "' string" },
          { "(", desc = "() block" },
          { ")", desc = "() block with ws" },
          { "<", desc = "<> block" },
          { ">", desc = "<> block with ws" },
          { "?", desc = "user prompt" },
          { "U", desc = "use/call without dot" },
          { "[", desc = "[] block" },
          { "]", desc = "[] block with ws" },
          { "_", desc = "underscore" },
          { "`", desc = "` string" },
          { "a", desc = "argument" },
          { "b", desc = ")]} block" },
          { "c", desc = "class" },
          { "d", desc = "digit(s)" },
          { "e", desc = "CamelCase / snake_case" },
          { "f", desc = "function" },
          { "g", desc = "entire file" },
          { "i", desc = "indent" },
          { "o", desc = "block, conditional, loop" },
          { "q", desc = "quote `\"'" },
          { "t", desc = "tag" },
          { "u", desc = "use/call" },
          { "{", desc = "{} block" },
          { "}", desc = "{} with ws" },
        }

        local ret = { mode = { "o", "x" } }
        ---@type table<string, string>
        local mappings = vim.tbl_extend("force", {}, {
          around = "a",
          inside = "i",
          around_next = "an",
          inside_next = "in",
          around_last = "aN",
          inside_last = "iN",
        }, {})
        mappings.goto_left = nil
        mappings.goto_right = nil

        for name, prefix in pairs(mappings) do
          name = name:gsub("^around_", ""):gsub("^inside_", "")
          ret[#ret + 1] = { prefix, group = name }
          for _, obj in ipairs(objects) do
            local desc = obj.desc
            if prefix:sub(1, 1) == "i" then
              desc = desc:gsub(" with ws", "")
            end
            ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
          end
        end
        require("which-key").add(ret, { notify = false })
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
