-- Messages: noice's command line and routes, snacks notifications and input styles.

return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.cmdline = {
        view = "cmdline",
        format = {
          cmdline = { icon = "  " },
          search_down = { icon = " 🔍 󰄼" },
          search_up = { icon = " 🔍 " },
          help = { icon = " 󰋖" },
          lua = { icon = "  " },
        },
      }
      opts.lsp = vim.tbl_deep_extend("force", opts.lsp or {}, {
        progress = { enabled = true, format = "lsp_progress", format_done = "lsp_progress_done", view = "mini" },
      })
      opts.presets = vim.tbl_extend("force", opts.presets or {}, { lsp_doc_border = true })
      opts.routes = opts.routes or {}
      vim.list_extend(opts.routes, {
        {
          filter = {
            event = "msg_show",
            any = { { find = "No active Snippet" }, { find = "Hunk" } },
          },
          view = "mini",
        },
        { filter = { event = "notify", find = "No information available" }, opts = { skip = true } },
      })
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      styles = {
        -- upstream's dressing.nvim input border, carried over to snacks.input
        input = { border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" }, wo = { winblend = 0 } },
        notification = {
          border = "rounded",
          title_pos = "left",
          wo = {
            winhighlight = "LineNr:SnacksNotifierIconInfo",
            winblend = 0,
            wrap = false,
            conceallevel = 0,
            colorcolumn = "",
          },
        },
      },
    },
  },
}
