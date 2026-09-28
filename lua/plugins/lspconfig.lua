return {
    {
        "folke/snacks.nvim",
        --- Updated this section to align with approach taken in other LazyVim snacks configs
        ---@diagnostic disable-next-line: unused-local
        opts = function(_, opts)
            -- Credit for this section goes to exsesx
            -- https://github.com/LazyVim/LazyVim/discussions/4232#discussioncomment-11191278
            local snacks = require("snacks")
            snacks
                .toggle({
                    name = "Diagnostic Virtual Text",
                    color = {
                        enabled = "azure",
                        disabled = "orange",
                    },
                    get = function()
                        return vim.diagnostic.config().virtual_text
                    end,
                    set = function(state)
                        if state then
                            vim.diagnostic.config({ virtual_text = false })
                        else
                            vim.diagnostic.config({ virtual_text = true })
                        end
                    end,
                })
                :map("<leader>uv")
        end,
    },
    {
        "neovim/nvim-lspconfig",
        keys = {
            {
                "<leader>uv",
                function()
                    local current = vim.diagnostic.config().virtual_text
                    vim.diagnostic.config({ virtual_text = not current })
                end,
                desc = "Toggle diagnostic virtual text",
            },
        },
        opts = {
            servers = {
                marksman = {
                    enabled = false,
                },
                eslint = {
                    enabled = false,
                    settings = {
                        validate = "on",
                        packageManager = "yarn",
                        format = { enabled = false },
                        workingDirectory = { mode = "auto" },
                        quiet = true,
                        problems = { shortenToSingleLine = true },
                    },
                },
                oxlint = {
                    enabled = true,
                    settings = {
                        run = "onType",
                        fixKind = "all",
                    },
                },
                rust_analyzer = {
                    enabled = false,
                    settings = {
                        ["rust-analyzer"] = {
                            diagnostics = {
                                enabled = true,
                            },
                            cargo = {
                                allFeatures = false,
                                target = "aarch64-apple-darwin",
                            },
                            check = {
                                allTargets = false,
                                command = "check",
                                targets = { "aarch64-apple-darwin" },
                            },
                            hover = {
                                actions = {
                                    enabled = true,
                                },
                            },
                        },
                    },
                },
            },
        },
        init = function()
            local function fix_then_write(bufnr)
                local client = vim.lsp.get_clients({ bufnr = bufnr, name = "oxlint" })[1]
                if not client then
                    vim.cmd("noautocmd write")
                    return
                end

                local applied = false
                local orig = client.handlers["workspace/applyEdit"] or vim.lsp.handlers["workspace/applyEdit"]
                client.handlers["workspace/applyEdit"] = function(...)
                    applied = true
                    return orig(...)
                end

                client:exec_cmd({
                    title = "Apply Oxlint automatic fixes",
                    command = "oxc.fixAll",
                    arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
                })

                vim.wait(500, function() return applied end, 20)
                client.handlers["workspace/applyEdit"] = orig
                vim.cmd("noautocmd write")
            end

            local group = vim.api.nvim_create_augroup("OxlintFixOnSave", { clear = true })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    if client.name == "oxlint" then
                        vim.api.nvim_clear_autocmds({ group = group, buffer = args.buf })
                        vim.api.nvim_create_autocmd("BufWriteCmd", {
                            group = group,
                            buffer = args.buf,
                            callback = function() fix_then_write(args.buf) end,
                        })
                    elseif client.name == "vtsls" or client.name == "ts_ls" or client.name == "tsserver"
                        or client.name == "eslint" or client.name == "tsgo" then
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                        client.server_capabilities.documentOnTypeFormattingProvider = false
                    end
                end,
            })
        end,
    }
}
