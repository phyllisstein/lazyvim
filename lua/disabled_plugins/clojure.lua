if true then return {} end

return {
    {
        "hrsh7th/nvim-cmp",
        optional = true,
        dependencies = {
            "PaterJason/cmp-conjure",
        },
        opts = function(_, opts)
            if type(opts.sources) == "table" then
                vim.list_extend(opts.sources, { name = "clojure" })
            end
        end,
    }
}
