return {
  {
    "PaterJason/nvim-treesitter-sexp",
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- LazyVim config for treesitter
      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "clojure",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown_inline",
        "markdown",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      exclude = {
        "latex",
      },
    },
  }
}
