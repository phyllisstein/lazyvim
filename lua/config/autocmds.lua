-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.b.textwidth = 80
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "latex" },
  callback = function()
    vim.b.textwidth = 80
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  callback = function()
    if vim.bo.filetype ~= "markdown" then
      vim.b.autoformat = true
    end
  end,
})

-- Relative line numbers only where you're moving around: the current window, while Neovim has
-- focus, outside INSERT and `:` command lines. Everywhere else they're absolute, so other splits,
-- an unfocused editor and typed ranges (`:12,40d`) show real line numbers. Windows without
-- 'number' (neo-tree, terminals, the dashboard) are left alone.
local number_toggle = vim.api.nvim_create_augroup("user_number_toggle", { clear = true })
local focused = true

local function set_relative(relative)
  if vim.wo.number then
    vim.wo.relativenumber = relative
  end
end

local function wants_relative()
  return focused and not vim.api.nvim_get_mode().mode:match("^[iR]")
end

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = number_toggle,
  callback = function()
    set_relative(false)
  end,
})
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter", "BufWinEnter" }, {
  group = number_toggle,
  callback = function()
    set_relative(wants_relative())
  end,
})
vim.api.nvim_create_autocmd({ "FocusLost", "FocusGained" }, {
  group = number_toggle,
  callback = function(ev)
    focused = ev.event == "FocusGained"
    set_relative(wants_relative())
  end,
})
-- `/` and `?` searches keep relative numbers; only `:` switches.
vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = number_toggle,
  pattern = ":",
  callback = function()
    if vim.wo.number and vim.wo.relativenumber then
      set_relative(false)
      vim.cmd.redraw() -- the command line doesn't redraw the window on its own
    end
  end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = number_toggle,
  pattern = ":",
  callback = function()
    set_relative(focused)
  end,
})
