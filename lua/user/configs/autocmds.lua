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
      -- trigger BufEnter again for DirOpened handlers
      vim.api.nvim_exec_autocmds(ev.event, { buffer = ev.buf, data = ev.data })
    end
  end,
})

-- Trigger event LazyFile
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufAdd", "BufWritePre" }, {
  group = utils.augroup("LazyFile"),
  nested = true,
  callback = function()
    vim.api.nvim_del_augroup_by_id(utils.augroup("LazyFile"))
    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile" })
  end,
})

-- Trigger event BufEnterNormal/BufEnterSpecial
vim.api.nvim_create_autocmd("BufEnter", {
  group = utils.augroup("CheckBufType"),
  callback = function()
    -- HACK: schedule the function since the buftype may haven't be set yet
    vim.schedule(function()
      local bufnr = vim.api.nvim_get_current_buf()
      if utils.is_real_file(bufnr) then
        vim.api.nvim_exec_autocmds("User", { pattern = "BufEnterNormal" })
      else
        vim.api.nvim_exec_autocmds("User", { pattern = "BufEnterSpecial" })
      end
    end)
  end,
})

-- Trigger event BufTypeNormal/BufTypeSpecial
vim.api.nvim_create_autocmd("FileType", {
  group = utils.augroup("CheckBufTypeOnce"),
  callback = function()
    -- HACK: schedule the function since the buftype may haven't be set yet
    vim.schedule(function()
      local bufnr = vim.api.nvim_get_current_buf()
      if utils.is_real_file(bufnr) then
        vim.api.nvim_exec_autocmds("User", { pattern = "BufTypeNormal" })
      else
        vim.api.nvim_exec_autocmds("User", { pattern = "BufTypeSpecial" })
      end
    end)
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd("BufWritePre", {
  group = utils.augroup("AutoCreateDir"),
  callback = function(ev)
    if ev.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(ev.match) or ev.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
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
vim.api.nvim_create_autocmd("User", {
  pattern = "BufTypeSpecial",
  group = utils.augroup("EasyCloseSpecialWin"),
  callback = function(ev)
    -- q maps to qall in startup page
    local exclude = { "alpha", "dashboard" }
    if not vim.tbl_contains(exclude, vim.bo[ev.buf].filetype) then
      vim.keymap.set("n", "q", function()
        local win = vim.api.nvim_get_current_win()
        pcall(vim.api.nvim_set_current_win, vim.g.last_normal_win)
        pcall(vim.api.nvim_win_close, win, false)
      end, { buffer = ev.buf, desc = "Quit Window" })
    end
  end,
})

-- Change working directory
vim.api.nvim_create_autocmd("User", {
  pattern = "BufEnterNormal",
  group = utils.augroup("AutoChdir"),
  callback = function(ev)
    local root = utils.workspace_root(ev.buf)
    if root ~= vim.loop.cwd() then
      vim.fn.chdir(root)
    end
  end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = utils.augroup("AutoChdir"),
  callback = function(ev)
    if utils.is_real_file(ev.buf, true) then
      local root = utils.workspace_root(ev.buf, true)
      if root ~= vim.loop.cwd() and ev.buf == vim.api.nvim_get_current_buf() then
        vim.fn.chdir(root)
      end
    end
  end,
})
vim.api.nvim_create_autocmd("LspAttach", {
  group = utils.augroup("AutoChdir"),
  callback = function(ev)
    local root = utils.workspace_root(ev.buf, true)
    if root ~= vim.loop.cwd() and ev.buf == vim.api.nvim_get_current_buf() then
      vim.fn.chdir(root)
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
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   group = augroup("HighlightYank"),
--   callback = function()
--     vim.highlight.on_yank({ higroup = "Search" })
--   end,
-- })

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = utils.augroup("WrapSpell"),
  pattern = { "gitcommit", "gitrebase", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
