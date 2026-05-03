if true then return {} end

return {
  "olrtg/nvim-emmet",
  init = function()
    vim.keymap.set({ "n", "v" }, '<leader>Mw', require('nvim-emmet').wrap_with_abbreviation)
  end,
}
