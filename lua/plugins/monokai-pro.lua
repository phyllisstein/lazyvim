return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = {},
  },
  {
    "loctvl842/monokai-pro.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    priority = 1000,
    opts = {
      devicons = true,
      -- terminal_colors = false,
      inc_search = "underline", -- underline | background
      background_clear = {
        -- "float_win",
        "toggleterm",
        "telescope",
        "which-key",
        "renamer",
        "notify",
        "nvim-tree",
        "neo-tree",
        "bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
      },-- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree", "nvim-tree", "bufferline"
      plugins = {
        bufferline = {
          underline_selected = false,
          underline_visible = false,
        },
        indent_blankline = {
          context_highlight = "default", -- default | pro
          context_start_underline = true,
        },
        treesitter = {},
      },
    },
    init = function ()
      vim.cmd([[colorscheme monokai-pro]])
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "monokai-pro",
    },
  },
}
