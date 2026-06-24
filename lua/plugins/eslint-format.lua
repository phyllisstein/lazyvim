return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          settings = {
            validate = "on",
            packageManager = "yarn",
            format = { enable = true },
            workingDirectory = { mode = "auto" },
            quiet = true,
            problems = { shortenToSingleLine = true },
          },
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client.name == "eslint" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function() vim.cmd("LspEslintFixAll") end,
            })
          elseif client.name == "vtsls" or client.name == "ts_ls" or client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            client.server_capabilities.documentOnTypeFormattingProvider = false
          end
        end,
      })
    end,
  },
}
