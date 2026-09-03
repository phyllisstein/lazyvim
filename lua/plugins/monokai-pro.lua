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
                inc_search = "background", -- underline | background
                background_clear = {
                    "toggleterm",
                    "telescope",
                    "renamer",
                    "notify",
                },
                plugins = {
                    { name = "neo-tree", lazy = { module = "neo-tree", event = "FileType neo-tree" } },
                },
            })
            vim.cmd.colorscheme("monokai-pro")
        end,
        init = function()
        end,
    },
}
