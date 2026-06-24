return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    -- Only one of these is needed.
    "esmuellert/codediff.nvim",      -- optional

    -- Only one of these is needed.
    -- "nvim-telescope/telescope.nvim", -- optional
    -- "ibhagwan/fzf-lua",              -- optional
    -- "nvim-mini/mini.pick",           -- optional
    -- "folke/snacks.nvim",             -- optional
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
  }
}
