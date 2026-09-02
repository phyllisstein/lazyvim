return {
    {
        "kylechui/nvim-surround",
        branch = "main",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                no_mappings = true,
            })

            -- vim.keymap.set("i", "<C-g>s", "<Plug>(nvim-surround-insert)", {
            --     desc = "Add a surrounding pair around the cursor (insert mode)",
            -- })
            -- vim.keymap.set("i", "<C-g>S", "<Plug>(nvim-surround-insert-line)", {
            --     desc = "Add a surrounding pair around the cursor, on new lines (insert mode)",
            -- })
            -- vim.keymap.set("n", "ys", "<Plug>(nvim-surround-normal)", {
            --     desc = "Add a surrounding pair around a motion (normal mode)",
            -- })
            -- vim.keymap.set("n", "yss", "<Plug>(nvim-surround-normal-cur)", {
            --     desc = "Add a surrounding pair around the current line (normal mode)",
            -- })
            -- vim.keymap.set("n", "yS", "<Plug>(nvim-surround-normal-line)", {
            --     desc = "Add a surrounding pair around a motion, on new lines (normal mode)",
            -- })
            -- vim.keymap.set("n", "ySS", "<Plug>(nvim-surround-normal-cur-line)", {
            --     desc = "Add a surrounding pair around the current line, on new lines (normal mode)",
            -- })
            -- vim.keymap.set("x", "S", "<Plug>(nvim-surround-visual)", {
            --     desc = "Add a surrounding pair around a visual selection",
            -- })
            -- vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)", {
            --     desc = "Add a surrounding pair around a visual selection, on new lines",
            -- })
            -- vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)", {
            --     desc = "Delete a surrounding pair",
            -- })
            -- vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)", {
            --     desc = "Change a surrounding pair",
            -- })
            -- vim.keymap.set("n", "cS", "<Plug>(nvim-surround-change-line)", {
            --     desc = "Change a surrounding pair, putting replacements on new lines",
            -- })
        end,
    },
    {
        "nvim-mini/mini.surround",
        enabled = false,
    }
}
