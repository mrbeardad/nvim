return {
  kind = {
    Array = "",
    Boolean = "",
    Class = "",
    Color = "",
    Constant = "",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "",
    File = "",
    Folder = "󰉋",
    Function = "",
    Interface = "",
    Key = "",
    Keyword = "",
    Method = "",
    Module = "",
    Namespace = "",
    Null = "󰟢",
    Number = "",
    Object = "",
    Operator = "",
    Package = "",
    Property = "",
    Reference = "",
    Snippet = "",
    String = "",
    Struct = "",
    Text = "",
    TypeParameter = "",
    Unit = "",
    Value = "",
    Variable = "",
  },
  ui = {
    ArrowCircleDown = "",
    ArrowCircleLeft = "",
    ArrowCircleRight = "",
    ArrowCircleUp = "",
    BoldArrowDown = "",
    BoldArrowLeft = "",
    BoldArrowRight = "",
    BoldArrowUp = "",
    BoldClose = "",
    BoldDividerLeft = "",
    BoldDividerRight = "",
    BoldLineLeft = "▎",
    BookMark = "",
    BoxChecked = "",
    Bug = "",
    Stacks = "",
    Scopes = "",
    Watches = "󰂥",
    DebugConsole = "",
    Calendar = "",
    Check = "",
    ChevronRight = "",
    ChevronShortDown = "",
    ChevronShortLeft = "",
    ChevronShortRight = "",
    ChevronShortUp = "",
    Circle = " ",
    Close = "󰅖",
    CloudDownload = "",
    Code = "",
    Comment = "",
    Dashboard = "",
    DividerLeft = "",
    DividerRight = "",
    DoubleChevronRight = "»",
    Ellipsis = "",
    EmptyFolder = "",
    EmptyFolderOpen = "",
    File = "",
    FileSymlink = "",
    Files = "",
    FindFile = "󰈞",
    FindText = "󰊄",
    Fire = "",
    Folder = "󰉋",
    FolderOpen = "",
    FolderSymlink = "",
    Forward = "",
    Gear = "",
    History = "",
    Lightbulb = "",
    LineLeft = "▏",
    LineMiddle = "│",
    List = "",
    Lock = "",
    NewFile = "",
    Note = "",
    Package = "",
    Pencil = "󰏫",
    Plus = "",
    Project = "",
    Search = "",
    SignIn = "",
    SignOut = "",
    Tab = "󰌒",
    Table = "",
    Target = "󰀘",
    Telescope = "",
    Text = "",
    Tree = "",
    Triangle = "󰐊",
    TriangleShortArrowDown = "",
    TriangleShortArrowLeft = "",
    TriangleShortArrowRight = "",
    TriangleShortArrowUp = "",
  },
  file = {
    modified = "●",
    readonly = "",
    unnamed = "",
    newfile = "",
  },
  diff = {
    ignored = "",
    added = "",
    modified = "",
    deleted = "",
    renamed = "",
  },
  diagnostics = {
    error = "",
    warn = "",
    info = "",
    hint = "",
    question = "",
  },
  -- TODO: clean nvim tree spec
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "User DirOpened" },
    keys = { { "<Leader>e", "<Cmd>lua require('nvim-tree.api').tree.toggle()<CR>" } },
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
    opts = {
      hijack_cursor = true,
      disable_netrw = true,
      view = {
        width = 40,
      },
      --sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        -- TODO: set cwd to root manually
        update_root = true,
        ignore_list = { "help" },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      modified = {
        enable = true,
      },
      renderer = {
        group_empty = true,
        full_name = true,
        root_folder_label = ":~",
        highlight_git = true,
        highlight_diagnostics = true,
        indent_markers = {
          enable = true,
        },
        icons = {
          git_placement = "after",
          modified_placement = "before",
          web_devicons = {
            folder = {
              enable = true,
            },
          },
          symlink_arrow = "⇒",
          glyphs = {
            folder = {
              arrow_closed = "",
              arrow_open = "",
            },
            git = {
              ignored = "",
              untracked = "",
              unstaged = "",
              staged = "",
              renamed = "",
              deleted = "",
              unmerged = "",
            },
          },
        },
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, silent = true, nowait = true }
        end

        -- help
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
        -- motion
        vim.keymap.set("n", "<CR>", api.tree.change_root_to_node, opts("Change Root"))
        vim.keymap.set("n", "<BS>", api.tree.change_root_to_parent, opts("Change Root To Parent"))
        vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
        vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Prev Sibling"))
        vim.keymap.set("n", "{", api.node.navigate.sibling.first, opts("First Sibling"))
        vim.keymap.set("n", "}", api.node.navigate.sibling.last, opts("Last Sibling"))
        vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
        vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
        vim.keymap.set("n", "]d", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
        vim.keymap.set("n", "[d", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
        vim.keymap.set("n", "[[", api.node.navigate.parent, opts("Parent Directory"))
        -- filter
        vim.keymap.set("n", "/", api.live_filter.start, opts("Filter"))
        vim.keymap.set("n", "H", api.tree.toggle_custom_filter, opts("Toggle Filter: Hidden"))
        vim.keymap.set("n", ".", api.tree.toggle_hidden_filter, opts("Toggle Filter: Dotfiles"))
        vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Filter: Git Ignore"))
        vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle Filter: No Buffer"))
        vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Filter: Git Clean"))
        vim.keymap.set("n", "zm", api.tree.collapse_all, opts("Collapse All"))
        vim.keymap.set("n", "zr", api.tree.expand_all, opts("Expand All"))
        vim.keymap.set("n", "K", api.node.show_info_popup, opts("Info"))
        -- open
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
        -- operation
        vim.keymap.set("n", "a", api.fs.create, opts("Create File Or Directory"))
        vim.keymap.set("n", "r", api.fs.rename_basename, opts("Rename Basename"))
        vim.keymap.set("n", "R", api.fs.rename, opts("Rename Full path"))
        vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
        vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
        vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
        vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "Y", api.fs.copy.absolute_path, opts("Copy Path"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "o", api.node.run.system, opts("Open By System"))
        vim.keymap.set("n", "!", api.node.run.cmd, opts("Run Command"))
        vim.keymap.set("n", "md", api.marks.bulk.delete, opts("Delete Bookmarked"))
        vim.keymap.set("n", "mD", api.marks.bulk.trash, opts("Trash Bookmarked"))
        vim.keymap.set("n", "mv", api.marks.bulk.move, opts("Move Bookmarked"))
        vim.keymap.set("n", "mm", api.marks.toggle, opts("Toggle Bookmark"))
        -- quit
        vim.keymap.set("n", "q", api.tree.close, opts("Close"))
        vim.keymap.set("n", "<Tab>", function()
          local before = vim.api.nvim_get_current_win()
          vim.cmd("winc p")
          local after = vim.api.nvim_get_current_win()
          if before == after then
            vim.cmd("winc w")
          end
        end, opts("Leave"))
      end,
    },
    --cond = false,
  },
}
