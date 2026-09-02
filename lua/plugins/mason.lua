
return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    opts = {
        ensure_installed = {
            "rust_analyzer",
            "oxlint",
        },
        automatic_enable = {
            exclude = {
                "bacon_ls",
                "latex",
                "oxfmt",
                "marksman",
                "markdownlint-cli2",
                "tsgo",
            }
        }
    },
}
