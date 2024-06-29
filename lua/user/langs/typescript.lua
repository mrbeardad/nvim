return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "javascript", "jsdoc", "typescript", "tsx" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {
          enabled = false,
        },
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = true },
              },
            },
          },
        },
      },
      setup = {
        tsserver = function()
          -- disable tsserver
          return true
        end,
        vtsls = function(_, opts)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local buffer = args.buf ---@type number
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and (client.name == "vtsls") then
                client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
                  ---@type string, string, lsp.Range
                  local action, uri, range = unpack(command.arguments)

                  local function move(newf)
                    client.request("workspace/executeCommand", {
                      command = command.command,
                      arguments = { action, uri, range, newf },
                    })
                  end

                  local fname = vim.uri_to_fname(uri)
                  client.request("workspace/executeCommand", {
                    command = "typescript.tsserverRequest",
                    arguments = {
                      "getMoveToRefactoringFileSuggestions",
                      {
                        file = fname,
                        startLine = range.start.line + 1,
                        startOffset = range.start.character + 1,
                        endLine = range["end"].line + 1,
                        endOffset = range["end"].character + 1,
                      },
                    },
                  }, function(_, result)
                    ---@type string[]
                    local files = result.body.files
                    table.insert(files, 1, "Enter new path...")
                    vim.ui.select(files, {
                      prompt = "Select move destination:",
                      format_item = function(f)
                        return vim.fn.fnamemodify(f, ":~:.")
                      end,
                    }, function(f)
                      if f and f:find("^Enter new path") then
                        vim.ui.input({
                          prompt = "Enter move destination:",
                          default = vim.fn.fnamemodify(fname, ":h") .. "/",
                          completion = "file",
                        }, function(newf)
                          return newf and move(newf)
                        end)
                      elseif f then
                        move(f)
                      end
                    end)
                  end)
                end
              end
            end,
          })
          -- copy typescript settings to javascript
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
      },
    },
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascriptreact", "typescriptreact" },
    opts = {},
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "eslint" },
        javascriptreact = { "eslint" },
        typescript = { "eslint" },
        typescriptreact = { "eslint" },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "eslint-lsp", "prettier" })
    end,
  },
}
