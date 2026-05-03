if true then return {} end

return {
    {
        "nvim-mini/mini-indentscope",
         enabled = false,
    },
    {
        "snacks.nvim",
        opts = {
            indent = { enabled = false },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        optional = false,
        opts = {
            scope = {
                enabled = true,
                show_end = true,
                show_start = true,
            }
        }
    },
}
