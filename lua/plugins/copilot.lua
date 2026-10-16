-- Copilot runs through the native LSP client (the ai.copilot-native extra, which sidekick's next-edit
-- suggestions also use). zbirenbaum/copilot.lua used to run here too, as a second Copilot server
-- feeding the same ghost text. Sign in with :LspCopilotSignIn.

-- No suggestions in prose.
local OFF_FILETYPES = { "markdown", "latex", "tex" }

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_copilot_filetypes", { clear = true }),
  pattern = OFF_FILETYPES,
  callback = function(args)
    vim.lsp.inline_completion.enable(false, { bufnr = args.buf })
  end,
})

return {
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
    opts = function()
      Snacks.toggle({
        name = "Copilot Completion",
        color = { enabled = "azure", disabled = "orange" },
        get = function()
          return vim.lsp.inline_completion.is_enabled()
        end,
        set = function(state)
          vim.lsp.inline_completion.enable(state)
        end,
      }):map("<leader>aP")
    end,
  },
}
