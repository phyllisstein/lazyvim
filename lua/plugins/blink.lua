if true then return {} end

return {
  "saghen/blink.cmp",
  dependencies = {
    "saghen/blink.lib",
  },
  build = function()
    require('blink.cmp').build():pwait()
  end,
  opts = {
    keymap = { preset  = "super-tab" },
    appearance = {
      nerd_font_variant = "normal",
    },
    -- sources = {
    --   transform_items = function(_, items)
    --     return vim.tbl_filter(function(item)
    --       return item.kind ~= require('blink.cmp.types').CompletionItemKind.Buffer
    --     end, items)
    --   end,
    --   providers = {
    --     buffer = {
    --       enabled = false
    --     }
    --   }
    -- },
    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = true,
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
        direction_priority = function()
          local ctx = require('blink.cmp').get_context()
          local item = require('blink.cmp').get_selected_item()
          if ctx == nil or item == nil then return { 's', 'n' } end

          local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
          local is_multi_line = item_text:find('\n') ~= nil

          -- after showing the menu upwards, we want to maintain that direction
          -- until we re-open the menu, so store the context id in a global variable
          if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
            vim.g.blink_cmp_upwards_ctx_id = ctx.id
            return { 'n', 's' }
          end
          return { 's', 'n' }
        end,
      }
    }
  },
}
