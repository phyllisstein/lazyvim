-- rust-analyzer runs through rustaceanvim, so its settings go here (merged into the LazyVim Rust
-- extra's `default_settings`), not under nvim-lspconfig. Names and values follow rust-analyzer's
-- configuration reference: https://rust-analyzer.github.io/book/configuration.html

-- codelldb from PATH, skipping Mason's bin directory (Mason prepends it, and mason-nvim-dap
-- installs its own codelldb via lua/plugins/dap.lua).
local function system_codelldb()
    local mason_bin = vim.fs.normalize(vim.fn.expand("$MASON/bin"))
    for dir in vim.gsplit(vim.env.PATH or "", ":", { plain = true }) do
        local path = vim.fs.joinpath(dir, "codelldb")
        if vim.fs.normalize(dir) ~= mason_bin and vim.fn.executable(path) == 1 then
            return path
        end
    end
end

return {
    "mrcjkb/rustaceanvim",
    -- Replaces the LazyVim Rust extra's config, which (whenever Mason is installed) pairs whatever
    -- `codelldb` is first on PATH with Mason's liblldb. Instead: run your PATH codelldb directly, as
    -- rustaceanvim itself would (codelldb finds its own LLDB); with none, leave `dap` unset so
    -- rustaceanvim's own detection applies.
    config = function(_, opts)
        local codelldb = system_codelldb()
        if codelldb then
            opts.dap = {
                adapter = {
                    type = "server",
                    host = "127.0.0.1",
                    port = "${port}",
                    executable = { command = codelldb, args = { "--port", "${port}" } },
                },
            }
        end
        vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
        if vim.fn.executable("rust-analyzer") == 0 then
            LazyVim.error(
                "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
                { title = "rustaceanvim" }
            )
        end
    end,
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
