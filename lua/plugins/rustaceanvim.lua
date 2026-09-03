return {
    "mrcjkb/rustaceanvim",
    opts = function(_, opts)
        opts.dap = nil  -- let rustaceanvim find codelldb itself
        return opts
    end,
}
