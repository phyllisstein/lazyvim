-- rust-analyzer runs through rustaceanvim, so its settings go here (merged into the LazyVim Rust
-- extra's `default_settings`), not under nvim-lspconfig. Names and values follow rust-analyzer's
-- configuration reference: https://rust-analyzer.github.io/book/configuration.html
return {
    "mrcjkb/rustaceanvim",
    opts = {
        server = {
            default_settings = {
                ["rust-analyzer"] = {
                    -- Only the targets you're building, not tests/benches/examples too (`--all-targets`).
                    -- Errors in those surface when you build or run them instead.
                    cargo = { allTargets = false },
                    check = { allTargets = false },

                    -- Proc-macro expansion failures (usually a server/toolchain mismatch or a not-yet-built
                    -- crate); the noise they cause outweighs the signal day to day.
                    diagnostics = { disabled = { "unresolved-proc-macro" } },

                    inlayHints = {
                        maxLength = 30, -- default 25; past this rust-analyzer elides with "…"
                        typeHints = {
                            hideClosureInitialization = true, -- `let f = |x| { .. }` needs no `impl Fn(..)`
                            hideNamedConstructor = true, -- `let x = Foo::new()` needs no `: Foo`
                        },
                        -- Make implicit rules visible while learning:
                        lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
                        expressionAdjustmentHints = { enable = "always" }, -- auto-(de)ref: &, *, &mut
                        implicitDrops = { enable = true }, -- where values are dropped
                    },

                    -- Every semantic token rust-analyzer can emit. Neovim draws them as @lsp.type.* /
                    -- @lsp.mod.* groups over Treesitter; tokens whose group the theme doesn't define
                    -- (most punctuation, in monokai-pro) change nothing until you style them.
                    semanticHighlighting = {
                        operator = { specialization = { enable = true } },
                        punctuation = {
                            enable = true,
                            separate = { macro = { bang = true } },
                            specialization = { enable = true },
                        },
                    },
                },
            },
        },
    },
}
