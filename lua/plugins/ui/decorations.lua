-- In-buffer decorations: indent guides with rainbow scope, keyword and color-literal highlights.

return {
  -- mini.hipatterns (below) covers TODO/FIXME/HACK/NOTE highlighting
  { "folke/todo-comments.nvim", enabled = false },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts)
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.SCOPE_ACTIVE, function(bufnr)
        return vim.api.nvim_buf_line_count(bufnr) < 2000
      end)
      opts.debounce = 200
      opts.indent = { char = "▏", tab_char = "▏" }
      opts.scope = {
        enabled = true,
        injected_languages = true,
        show_start = true,
        show_end = false,
        char = "▏",
        -- defined in monokai-pro.lua's override, since rainbow-delimiters isn't installed
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
      vim.list_extend(opts.exclude.filetypes, { "startify", "packer", "neogitstatus", "NvimTree" })
      opts.exclude.buftypes = { "terminal", "nofile" }
      return opts
    end,
  },

  {
    "nvim-mini/mini.hipatterns",
    opts = function(_, opts)
      -- pigmentor handles color literals
      opts.highlighters.hex_color = nil
      opts.highlighters.shorthand = nil
      opts.highlighters.fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" }
      opts.highlighters.hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" }
      opts.highlighters.todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" }
      opts.highlighters.note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" }
      opts.highlighters.wip = { pattern = "%f[%w]()WIP()%f[%W]", group = "MiniHipatternsWip" }
    end,
  },

  {
    "ImmanuelHaffner/pigmentor.nvim",
    event = "LazyFile",
    opts = {
      display = {
        style = "highlight",
        highlight = { inverted = true, padding = { left = 0, right = 0 } },
      },
    },
  },
}
