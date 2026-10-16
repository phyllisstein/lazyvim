-- codelldb comes from PATH (see lua/plugins/rustaceanvim.lua), so Mason never installs it. Three
-- routes would: mason-nvim-dap's ensure_installed, the LazyVim Rust extra adding it to Mason's own
-- ensure_installed, and the dap extra's automatic_installation, which installs a package for any
-- adapter registered with nvim-dap (rustaceanvim registers "codelldb").
local function without_codelldb(list)
    return vim.tbl_filter(function(name)
        return name ~= "codelldb"
    end, list or {})
end

return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        opts = function(_, opts)
            opts.ensure_installed = without_codelldb(opts.ensure_installed)
            -- Add to, don't replace, exclusions other extras set (the TypeScript one excludes "chrome").
            local auto = opts.automatic_installation
            if auto ~= false then
                local exclude = type(auto) == "table" and auto.exclude or {}
                opts.automatic_installation = { exclude = vim.list_extend(vim.deepcopy(exclude), { "codelldb" }) }
            end
        end,
    },
    {
        "mason-org/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = without_codelldb(opts.ensure_installed)
        end,
    },
}
