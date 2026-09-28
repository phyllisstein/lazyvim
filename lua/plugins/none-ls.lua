return {
    "nvimtools/none-ls.nvim",
    enabled = false,
    opts = function(_, opts)
        opts.sources = vim.tbl_filter(function(source)
            return source.name ~= "markdownlint_cli2"
        end, opts.sources)
    end,
}
