local utils = require("user.utils")

-- Trigger event LazyDir
vim.api.nvim_create_autocmd("BufEnter", {
  group = utils.augroup("LazyDir"),
  nested = true,
  callback = function(ev)
    local bufname = vim.api.nvim_buf_get_name(ev.buf)
    local stat = vim.loop.fs_stat(bufname)
    if stat and stat.type == "directory" then
      vim.api.nvim_del_augroup_by_id(utils.augroup("LazyDir"))
      vim.api.nvim_exec_autocmds("User", { pattern = "LazyDir" })
      -- Trigger BufEnter again for DirOpened handlers
      vim.api.nvim_exec_autocmds(ev.event, { buffer = ev.buf, data = ev.data })
    end
  end,
})

-- Trigger event LazyFile
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufAdd" }, {
  group = utils.augroup("LazyFile"),
  nested = true,
  callback = function()
    vim.api.nvim_del_augroup_by_id(utils.augroup("LazyFile"))
    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile" })
  end,
})

-- Remenber the last normal winid
vim.g.last_normal_win = 0
vim.api.nvim_create_autocmd("WinLeave", {
  group = utils.augroup("LastNormalWin"),
  callback = function()
    local winid = vim.api.nvim_get_current_win()
    if not utils.is_floating(winid) and utils.is_real_file() then
      vim.g.last_normal_win = winid
    end
  end,
})

-- Close special windows with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = utils.augroup("EasyCloseSpecialWin"),
  callback = function(ev)
    local exclude = { "alpha", "noice" }
    if vim.bo[ev.buf].buftype ~= "" and not vim.tbl_contains(exclude, vim.bo[ev.buf].filetype) then
      vim.keymap.set(
        "n",
        "q",
        "<Cmd>close<Bar>call win_gotoid(g:last_normal_win)<CR>",
        { buffer = ev.buf, desc = "Quit Window" }
      )
    end
  end,
})

-- Change working directory to workspace root
local current_buf = 0
vim.api.nvim_create_autocmd("BufEnter", {
  group = utils.augroup("AutoChdir"),
  nested = true,
  callback = function(ev)
    current_buf = ev.buf
    if utils.is_real_file(current_buf) then
      local root = utils.workspace_root()
      if root ~= vim.loop.cwd() then
        vim.fn.chdir(root)
      end
    end
  end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = utils.augroup("AutoChdir"),
  nested = true,
  callback = function(ev)
    if ev.buf == current_buf then
      local root = utils.workspace_root(true)
      if root ~= vim.loop.cwd() then
        vim.fn.chdir(root)
      end
    end
  end,
})
vim.api.nvim_create_autocmd("LspAttach", {
  group = utils.augroup("AutoChdir"),
  nested = true,
  callback = function(ev)
    if ev.buf == current_buf then
      local root = utils.workspace_root(true)
      if root ~= vim.loop.cwd() then
        vim.fn.chdir(root)
      end
    end
  end,
})

-- Go to last position when opening a buffer
vim.api.nvim_create_autocmd("BufRead", {
  group = utils.augroup("LastPositionJump"),
  callback = function(ev)
    vim.api.nvim_create_autocmd("FileType", {
      buffer = ev.buf,
      once = true,
      callback = function(evt)
        local exclude = { "gitcommit", "gitrebase" }
        if
          not vim.tbl_contains(exclude, vim.bo[evt.buf].filetype)
          and vim.fn.line("'\"") > 1
          and vim.fn.line("'\"") <= vim.fn.line("$")
        then
          vim.cmd('normal! g`"zz')
        end
      end,
    })
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = utils.augroup("Checktime"),
  command = "checktime",
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd("BufWritePre", {
  group = utils.augroup("AutoCreateDir"),
  callback = function(ev)
    if not ev.match:match("^%w%w+://") then
      local file = vim.loop.fs_realpath(ev.match) or ev.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = utils.augroup("ResizeSplits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Highlight on yank, do it by yanky
vim.api.nvim_create_autocmd("TextYankPost", {
  group = utils.augroup("HighlightYank"),
  callback = function()
    vim.highlight.on_yank({ higroup = "Search" })
  end,
})

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = utils.augroup("WrapSpell"),
  pattern = { "gitcommit", "gitrebase", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})
