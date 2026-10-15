return {
    {
        "loctvl842/monokai-pro.nvim",
        version = "*",
        lazy = false,
        priority = 1000,
        config = function()
            require("monokai-pro").setup({
                transparent_background = false,
                terminal_colors = true,
                devicons = true,
                styles = {
                    comment = { italic = true },
                    keyword = { italic = true },
                    type = { italic = true },
                    storageclass = { italic = true },
                    structure = { italic = true },
                    parameter = { italic = true },
                    annotation = { italic = true },
                    tag_attribute = { italic = true },
                },
                filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
                day_night = {
                    enable = false,
                    day_filter = "pro",
                    night_filter = "spectrum",
                },
                inc_search = "underline", -- underline | background
                background_clear = {
                    "toggleterm",
                    "telescope",
                    "renamer",
                    "notify",
                    "which-key",
                },
                plugins = {
                    bufferline = {
                        underline_selected = true,
                        underline_visible = false,
                        underline_fill = true,
                        bold = false,
                    },
                    indent_blankline = {
                        context_highlight = "pro", -- default | pro
                        context_start_underline = true,
                    },
                },
                -- Groups used by lua/plugins/ui.lua. monokai-pro caches highlights and only notices
                -- *whether* an override exists, so after editing this run
                -- :lua require("monokai-pro.theme").clear_cache()
                override = function(c)
                    return {
                        -- TreeSitter overrides
                        ["@punctuation.bracket"] = { link = "@punctuation.delimiter" }, -- link brackets to delimiters (dimmed2)
                        -- ["@punctuation.bracket.cpp"] = { link = "@punctuation.delimiter.cpp" }, -- languages that get specific delimieter highlighting would need to be handled separately

                        -- LSP inlay hints: a muted accent on a faint, darker-than-editor pill, so they
                        -- read as neither code nor comments (comments are dimmed3 italic). The padding in
                        -- lua/plugins/ui.lua sits inside the pill. Tune either strength (0-1) to taste;
                        -- c.base.dimmed4 is the plain-gray alternative for fg.
                        LspInlayHint = {
                            fg = require("monokai-pro.colors").blend(c.base.magenta, 0.4, c.editor.background),
                            bg = require("monokai-pro.colors").blend(c.base.dark, 0.45, c.editor.background),
                        },
                        -- monokai-pro's naming is off by one hue: c.base.blue is its orange (accent2);
                        -- the blue is c.base.cyan (accent5).
                        DiagnosticVirtualTextHint = {
                            fg = require("monokai-pro.colors").blend(c.base.cyan, 0.4, c.editor.background),
                            bg = "NONE",
                        },
                        DiagnosticSignHint = { link = "DiagnosticVirtualTextHint" },
                        DiagnosticVirtualTextError = {
                            fg = require("monokai-pro.colors").blend(c.base.red, 0.4, c.editor.background),
                            bg = "NONE",
                        },
                        DiagnosticSignError = { link = "DiagnosticVirtualTextError" },
                        DiagnosticVirtualTextWarn = {
                            fg = require("monokai-pro.colors").blend(c.base.yellow, 0.4, c.editor.background),
                            bg = "NONE",
                        },
                        DiagnosticSignWarn = { link = "DiagnosticVirtualTextWarn" },


                        DashboardRecent = { fg = c.base.magenta },
                        DashboardProject = { fg = c.base.blue },
                        DashboardConfiguration = { fg = c.base.white },
                        DashboardSession = { fg = c.base.green },
                        DashboardLazy = { fg = c.base.cyan },
                        DashboardServer = { fg = c.base.yellow },
                        DashboardQuit = { fg = c.base.red },
                        NeoTreeStatusLine = { link = "StatusLine" },
                        MiniHipatternsFixme = { fg = c.base.black, bg = c.base.red, bold = true },
                        MiniHipatternsTodo = { fg = c.base.black, bg = c.base.blue, bold = true },
                        MiniHipatternsHack = { fg = c.base.black, bg = c.base.yellow, bold = true },
                        MiniHipatternsNote = { fg = c.base.black, bg = c.base.green, bold = true },
                        MiniHipatternsWip = { fg = c.base.black, bg = c.base.cyan, bold = true },
                        -- indent-blankline's scope colors; monokai-pro only defines these once
                        -- rainbow-delimiters.nvim loads, and ibl errors on missing groups.
                        RainbowDelimiterRed = { fg = c.base.red },
                        RainbowDelimiterYellow = { fg = c.base.yellow },
                        RainbowDelimiterBlue = { fg = c.base.cyan },
                        RainbowDelimiterOrange = { fg = c.base.blue },
                        RainbowDelimiterGreen = { fg = c.base.green },
                        RainbowDelimiterViolet = { fg = c.base.magenta },
                        RainbowDelimiterCyan = { fg = c.base.cyan },
                    }
                end,
            })
            vim.cmd.colorscheme("monokai-pro")
        end,
        init = function()
        end,
    },
}
