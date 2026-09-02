return {
    {
        "loctvl842/monokai-pro.nvim",
        version = "*",
        lazy = false,
        priority = 1000,
        config = function()
            require("monokai-pro").setup({
                background_clear = {
                    "which-key",
                },
                plugins = {
                    "which-key",
                }
            })
            vim.cmd([[colorscheme monokai-pro]])
        end,
        init = function()
        end,
    },
}
