if true then return {} end

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      filetypes = {
        markdown = false,
        latex = false,
      },
    },
    init = function()
      vim.g.copilot_filetypes = { markdown = false }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      -- Set your preferred icon (Nerd Font/emoji) for the AI group
      table.insert(opts.spec, { "<leader>a", group = "AI", icon = "" })
      -- Examples: "󰚩", "", "ﮧ", "", "🤖"
    end,
  },
}
