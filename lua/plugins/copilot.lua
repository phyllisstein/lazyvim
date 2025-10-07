-- if true then return {} end

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      filetypes = {
        markdown = false,
        latex = false,
        tex = false,
      },
    },
    init = function()
      vim.g.copilot_filetypes = { markdown = false, latex = false, tex = false }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      -- Set your preferred icon (Nerd Font/emoji) for the AI group
      -- table.insert(opts.spec, { "<leader>a", group = "AI", icon = "" })
      -- Examples: "󰚩", "", "ﮧ", "", "🤖"
    end,
  },
  {
    "folke/snacks.nvim",
    --- Updated this section to align with approach taken in other LazyVim snacks configs
    ---@diagnostic disable-next-line: unused-local
    opts = function(_, opts)
      -- Credit for this section goes to exsesx
      -- https://github.com/LazyVim/LazyVim/discussions/4232#discussioncomment-11191278
      local snacks = require("snacks")
      -- Check whether Copilot is installed
      if pcall(require, "copilot") then
        --- Workaround to keep track of state
        vim.g.snacks_copilot_enabled = true
        snacks
          .toggle({
            name = "Copilot Completion",
            color = {
              enabled = "azure",
              disabled = "orange",
            },
            get = function()
              return vim.g.snacks_copilot_enabled
            end,
            set = function(state)
              if state then
                vim.g.snacks_copilot_enabled = true
                require("copilot.command").enable()
              else
                vim.g.snacks_copilot_enabled = false
                require("copilot.command").disable()
              end
            end,
          })
          :map("<leader>at")
      end
    end,
  }
}
