if true then return {} end

return {
    {
        "folke/snacks.nvim",
        opts = {
            explorer = {
                enabled = false,
            },
        },
    },
    {
        "kyazdani42/nvim-tree.lua",
        opts = {
            renderer = {
                icons = {
                    show = {
                        file = false,
                        folder = false,
                        folder_arrow = true,
                        git = false,
                    },
                },
            },
            trash = {
                cmd = "trash",
            },
            ui = {
                confirm = {
                    remove = true,
                    trash = false,
                    default_yes = true,
                },
            },
        },
    },
}
