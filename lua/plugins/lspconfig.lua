vim.keymap.set("n", "<leader>uv", function()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current })
end, { desc = "Toggle diagnostic virtual text" })

return {
    "neovim/nvim-lspconfig",
    keys = {
        {
            "<leader>uv",
            function()
                local current = vim.diagnostic.config().virtual_text
                vim.diagnostic.config({ virtual_text = not current })
            end,
            desc = "Toggle diagnostic virtual text",
            icon = "",
        },
    },
    opts = {
        servers = {
            marksman = {
                enable = false,
            },
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
            ["rust-analyzer"] = {
                settings = {
                    ["rust-analyzer"] = {
                        diagnostics = {
                            enable = true,
                            disabled = {
                                "unresolved-proc-macro",
                                "unused-imports",
                                "unused-variables",
                                "dead-code",
                            },
                        },
                        cargo = {
                            allFeatures = false,
                            allTargets = false,
                            target = "aarch64-apple-darwin",
                        },
                        check = {
                            command = "check",
                            targets = { "aarch64-apple-darwin" },
                        },
                        hover = {
                            actions = {
                                enable = true,
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
