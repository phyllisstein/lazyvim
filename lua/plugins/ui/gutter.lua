-- Gutter: statuscol's line number / sign / fold layout. Fold chevrons come from fillchars in
-- config/options.lua.

return {
  {
    "luukvbaal/statuscol.nvim",
    event = "VimEnter",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = false,
        ft_ignore = { "neo-tree", "snacks_dashboard" },
        segments = {
          { text = { builtin.lnumfunc, " " }, condition = { true, builtin.not_empty }, click = "v:lua.ScLa" },
          { text = { "%s" }, click = "v:lua.ScSa" },
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
        },
      })
    end,
  },
}
