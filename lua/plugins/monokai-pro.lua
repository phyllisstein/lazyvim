return {
    {
        "loctvl842/monokai-pro.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent_background = true,
            terminal_colors = false,
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
                "bufferline",
                "coc-explorer",
                "fern",
                "fern-renderer-nerdfont",
                "fidget",
                "fidget_title",
                "notify",
                "noice",
                "neo-tree",
                "nvim-tree",
                "telescope",
                "which-key",
            },
            plugins = {
                { name = "snacks.nvim", lazy = false },
                { name = "mini.nvim", lazy = false },
                { name = "lazy.nvim", lazy = false },
                bufferline = {
                    underline_selected = false,
                    underline_visible = false,
                    underline_fill = false,
                    bold = true,
                },
                indent_blankline = {
                    context_highlight = "pro", -- default | pro
                    context_start_underline = true,
                },
                { name = "treesitter", lazy = false },
                { name = "native_lsp", lazy = false },
                { name = "nvim_cmp", lazy = false },
                { name = "nvim_tree", lazy = false },
                { name = "telescope", lazy = false },
                { name = "indent-blankline.nvim", lazy = false },
            },
            override = function(scheme)
                return {}
            end,
            override_palette = function(filter)
                return {}
            end,
            override_scheme = function(scheme, palette, colors)
                return {}
            end,
        },
        init = function()
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
