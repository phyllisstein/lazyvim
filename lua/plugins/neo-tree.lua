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
    { 'nvim-mini/mini.nvim', version = '*' },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        lazy = false, -- neo-tree will lazily load itself
    }
}
