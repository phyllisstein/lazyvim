-- Windows: animated auto-resizing splits, and no smooth scrolling.

return {
  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = { "anuvyklack/middleclass", "anuvyklack/animation.nvim" },
    opts = {
      animation = { enable = true, duration = 150, fps = 60 },
      autowidth = { enable = true },
    },
    keys = { { "<leader>z", "<cmd>WindowsMaximize<CR>", desc = "Zoom window" } },
    init = function()
      vim.o.winwidth = 30
      vim.o.winminwidth = 30
      vim.o.equalalways = true
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
  },
}
