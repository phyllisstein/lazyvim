if true then return {} end

return {
    "andrewferrier/wrapping.nvim",
    config = function()
        require("wrapping").setup({
            auto_set_mode_heuristically = false
        })
    end
}
