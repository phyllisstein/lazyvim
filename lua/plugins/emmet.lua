return {
  "olrtg/nvim-emmet",
  init = function()
    vim.keymap.set({ "n", "v" }, '<leader>Mw', require('nvim-emmet').wrap_with_abbreviation)
  end,
}
