-- Skip loading. (Actually doesn't work super well.)
-- if true then
--   return {}
-- end

return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      -- "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
      -- "echasnovski/mini.pick", -- optional
    },
    event = "VeryLazy",
    keys = {
      {
        "<leader>gng",
        "<cmd>Neogit<cr>",
        desc = "Neogit",
      },
    },
    config = true,
    lazy = true,
    opts = {
      graph_style = "unicode",
      integrations = {
        telescope = true,
      },
    },
  },
}
