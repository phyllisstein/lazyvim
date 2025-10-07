if true then return {} end --- IGNORE ---

return {
  {
    "snacks.nvim",
    opts = {
      indent = { enabled = false },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      scope = {
        enabled = true,
        show_end = true,
        show_start = true,
      }
    }
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("rainbow-delimiters.setup").setup {
        strategies = {
          clojure = 'rainbow-delimiters.strategy.local'
        }
      }
    end
  }
}
