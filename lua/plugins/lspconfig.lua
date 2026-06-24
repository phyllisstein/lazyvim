return {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            bacon_ls = {
                enable = true,
            },
            rust_analyzer = {
                enable = true,
                settings = {
                    ["rust-analyzer"] = {
                        numThreads = 1,
                        diagnostics = {
                            enable = true,
                            disabled = {
                                "unresolved-proc-macro",
                                "unused-imports",
                                "unused-variables",
                                "dead-code",
                            },
                        },
                    },
                },
            },
        },
    },
}
