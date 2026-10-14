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

-- Relative line numbers in NORMAL, absolute in INSERT (like VSCodeVim's `vim.smartRelativeLine`).
-- Only touches windows that show numbers at all, so neo-tree, terminals, etc. stay as they are.
local number_toggle = vim.api.nvim_create_augroup("user_number_toggle", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = number_toggle,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = number_toggle,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})
