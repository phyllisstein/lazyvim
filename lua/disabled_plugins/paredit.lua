if true then return {} end

return {
  {
    "julienvincent/nvim-paredit",
    config = function()
      require("nvim-paredit").setup()
    end
  }
}
