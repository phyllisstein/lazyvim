return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      terminal_colors = false,
      devicons = false, -- highlight the icons of `nvim-web-devicons`
      transparent_background = true,
      filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
      inc_search = "underline", -- underline | background
      background_clear = {
        "float_win",
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
          context_highlight = "pro", -- default | pro | octagon
          context_start_underline = true,
        },
        native_lsp = {
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        lsp_semantic_tokens = true,
        telescope = true,
        treesitter = true,
        cmp = true,
        notify = true,
        mini = true,
        dashboard = true,
        harpoon = true,
        leap = true,
        lightspeed = true,
        mason = true,
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
