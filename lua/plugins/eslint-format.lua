-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      eslint = {
        settings = {
          validate = "on",
          packageManager = "yarn",
          format = { enable = true },
          workingDirectory = {
            mode = "auto",
          },
        },
      },
    },
    init = function()
      require("lazyvim.util").lsp.setup({
        on_attach = function(client, bufnr)
          if client.name == "eslint" then
            client.server_capabilities.documentFormattingProvider = true
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "LspEslintFixAll",
            })
          elseif client.name == "tsserver" or client.name == "vtsls" or client.name == "ts_ls" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            client.server_capabilities.documentOnTypeFormattingProvider = false
          end
        end,
      })
    end,
  },
}
