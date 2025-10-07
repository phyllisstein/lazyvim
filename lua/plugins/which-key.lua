return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      -- Set your preferred icon (Nerd Font/emoji) for the AI group
      table.insert(opts.spec, { "<leader>a", group = "ai", icon = "" })
      -- Examples: "󰚩", "", "ﮧ", "", "🤖"

      -- Items under +ai with their own icons
      vim.list_extend(opts.spec, {
        { "<leader>aa", desc = "Toggle (CopilotChat)",     icon = "󰚩" },
        { "<leader>ac", desc = "Prompt Actions (CopilotChat)", icon = "" },
        { "<leader>ae", desc = "Quick Chat (CopilotChat)",    icon = "" },
        { "<leader>ae", desc = "Clear (CopilotChat)",    icon = "" },
        -- add more as needed…
      })
    end,
  },
}
