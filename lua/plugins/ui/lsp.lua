-- LSP presentation: diagnostic signs and float, inlay hint padding. Colors for both live in
-- lua/plugins/monokai-pro.lua's override.

local ui = require("config.ui")


-- Spaces on each side of every inlay hint, replacing the single optional space servers ask for.
-- They're part of the label, so the hint's background covers them and each hint reads as a pill.
-- Neovim has no setting for this, so the public handler is wrapped to pad labels before drawing.
local INLAY_HINT_PADDING = 1

vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx)
  local pad = (" "):rep(INLAY_HINT_PADDING)
  for _, hint in ipairs(result or {}) do
    hint.paddingLeft, hint.paddingRight = false, false
    if type(hint.label) == "string" then
      hint.label = pad .. hint.label .. pad
    else
      table.insert(hint.label, 1, { value = pad })
      table.insert(hint.label, { value = pad })
    end
  end
  return vim.lsp.inlay_hint.on_inlayhint(err, result, ctx)
end

-- TODO: try chrisgrieser/nvim-lsp-endhints, which moves inlay hints to the end of the line so
-- code keeps its columns (marginalia instead of interlinear glosses). Mainly for Rust, where type
-- hints get long; parameter-name hints lose their anchor there, so it may want to be per-filetype.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = ui.diagnostic_icons.error,
            [vim.diagnostic.severity.WARN] = ui.diagnostic_icons.warn,
            [vim.diagnostic.severity.HINT] = ui.diagnostic_icons.hint,
            [vim.diagnostic.severity.INFO] = ui.diagnostic_icons.info,
          },
        },
        float = { style = "minimal", source = true, header = "", prefix = "" },
      },
    },
  },
}
