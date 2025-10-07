return {
  {
    "kylechui/nvim-surround",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "gs",
          normal_cur = "gss",
          normal_line = "gS",
          normal_cur_line = "gSS",
          visual = "gS",
          visual_line = "gS",
          delete = "gds",
          change = "gcs",
          change_line = "gcS",
        },
      })
    end,
  },
  {
    "nvim-mini/mini.surround",
    enabled = false,
  }
}
