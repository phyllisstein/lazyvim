
return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
    },
    opts = {
        ensure_installed = {
            "oxlint",
            "rust_analyzer",
            "ast_grep",
            "svelte",
        },
        automatic_enable = {
            exclude = {
                "latex",
                "oxfmt",
                "marksman",
                "markdownlint-cli2",
                "markdownlint",
                "bacon-ls",
            },
        },
    },
}
