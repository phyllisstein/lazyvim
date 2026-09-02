return {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            eslint = {
                enable = false,
                settings = {
                    validate = "on",
                    packageManager = "yarn",
                    format = { enable = false },
                    workingDirectory = { mode = "auto" },
                    quiet = true,
                    problems = { shortenToSingleLine = true },
                },
            },
            oxlint = {
                enable = true,
                settings = {
                    oxlint = {
                        enable = true,
                        lintOnInsert = true,
                        lintOnInsertDebounceMillis = 500,
                    },
                },
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
    init = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then return end

                if client.name == "oxlint" then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        callback = function() vim.cmd("LspOxlintFixAll") end,
                    })
                elseif client.name == "vtsls" or client.name == "ts_ls" or client.name == "tsserver" or client.name == "eslint" or client.name == "tsgo" then
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    client.server_capabilities.documentOnTypeFormattingProvider = false
                end
            end,
        })
    end,
}
