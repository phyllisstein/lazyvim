-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.o.backspace = "indent,eol,start"
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.o.fixendofline = true
vim.o.fixeol = true

-- UI, from loctvl842/nvim
vim.o.relativenumber = false
vim.o.numberwidth = 4
vim.o.foldcolumn = "1"
vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.scrolloff = 4
vim.o.sidescrolloff = 0
vim.o.title = true
vim.o.titlestring = "%<%F%=%l/%L - nvim"
vim.opt.fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
}
vim.opt.listchars = { tab = "  ", trail = "-", nbsp = "+" }
