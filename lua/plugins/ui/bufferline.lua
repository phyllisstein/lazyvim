-- Tab bar: slanted bufferline tabs with an EXPLORER offset over neo-tree.

local ui = require("config.ui")

return {
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<M-1>", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to buffer 1" },
      { "<M-2>", "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to buffer 2" },
      { "<M-3>", "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to buffer 3" },
      { "<M-4>", "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to buffer 4" },
      { "<M-5>", "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to buffer 5" },
      { "<M-6>", "<Cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to buffer 6" },
      { "<M-7>", "<Cmd>BufferLineGoToBuffer 7<CR>", desc = "Go to buffer 7" },
      { "<M-8>", "<Cmd>BufferLineGoToBuffer 8<CR>", desc = "Go to buffer 8" },
      { "<M-9>", "<Cmd>BufferLineGoToBuffer 9<CR>", desc = "Go to buffer 9" },
    },
    opts = {
      options = {
        buffer_close_icon = "󰅖",
        separator_style = "slant",
        always_show_bufferline = false,
        indicator = { style = "underline" },
        diagnostics_indicator = function(count)
          return count > 9 and "9+" or tostring(count)
        end,
        offsets = {
          { filetype = "neo-tree", text = "EXPLORER", text_align = "center", separator = ui.float },
          { filetype = "snacks_layout_box" },
        },
        hover = { enabled = true, delay = 0, reveal = { "close" } },
      },
    },
  },
}
