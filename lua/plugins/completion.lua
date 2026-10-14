-- Completion: one Tab for both blink's menu and Copilot's ghost text, partial ghost-text accept,
-- and no buffer-word suggestions. Ghost-text styling lives in lua/plugins/ui/ghost-text.lua.

local inline = vim.lsp.inline_completion

-- Accept the next word or line of the ghost text, leaving the rest suggested.
-- Copilot re-requests on the cursor move and normally offers the remainder again.
---@param unit "word"|"line"
local function accept_partial(unit)
  return inline.get({
    on_accept = function(item)
      if type(item.insert_text) ~= "string" then
        return item -- snippet suggestions are accepted whole
      end
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      row = row - 1
      local line = vim.api.nvim_get_current_line()

      -- The suggestion usually repeats what's already typed from range start to the cursor.
      local text, tail = item.insert_text, ""
      if item.range then
        local sr, sc, er, ec = item.range:to_extmark()
        if sr == row and sc <= col then
          local typed = line:sub(sc + 1, col)
          if text:sub(1, #typed) == typed then
            text = text:sub(#typed + 1)
          end
        end
        if er == row and ec > col then
          tail = line:sub(col + 1, ec) -- existing text the suggestion's first line replaces
        end
      end

      local chunk
      if unit == "word" then
        chunk = text:match("^%s*[%w_]+") or text:match("^%s*[^%w_%s]+") or text:match("^%s+")
      else
        chunk = text:match("^[^\n]*\n?")
      end
      if not chunk or chunk == "" or chunk == text then
        return item -- nothing left to split off: take it all
      end

      vim.api.nvim_paste(chunk, false, -1)
      -- Taking the whole first line also takes over the text it was meant to replace.
      if tail ~= "" and not text:sub(#chunk + 1):match("^[^\n]") then
        local r, c = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_text(0, r - 1, c, r - 1, c + #tail, {})
      end
      return nil -- handled here
    end,
  })
end

-- Global, not on the copilot server's `keys`: lazy.nvim replaces lists when merging specs, which
-- would drop the copilot-native extra's <M-]>/<M-[> (next/previous suggestion).
-- On macOS these need Option to send Alt (kitty: macos_option_as_alt; Ghostty: macos-option-as-alt).
vim.keymap.set("i", "<M-Right>", function()
  return not accept_partial("word") and "<M-Right>" or ""
end, { expr = true, desc = "Accept Copilot Word" })
vim.keymap.set("i", "<M-C-Right>", function()
  return not accept_partial("line") and "<M-C-Right>" or ""
end, { expr = true, desc = "Accept Copilot Line" })

return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- No buffer-word suggestions; LSP, paths and snippets only.
      opts.sources.default = vim.tbl_filter(function(s)
        return s ~= "buffer"
      end, opts.sources.default or {})

      -- <Tab>, in order:
      --   1. the menu item you moved to (deliberately, with <C-n>/<Down>), if the menu is open
      --   2. Copilot's ghost text, whole
      --   3. a next-edit suggestion (sidekick), then the next snippet placeholder
      --   4. the menu's top item, if the menu is open
      --   5. a literal tab
      -- <CR> still accepts the menu item, so with both showing: <Tab> ghost, <CR> menu.
      opts.keymap["<Tab>"] = {
        function(cmp)
          if cmp.is_menu_visible() and (cmp.get_selected_item_idx() or 1) > 1 then
            return cmp.accept()
          end
          if inline.get() then
            return true
          end
          if LazyVim.cmp.map({ "ai_nes", "snippet_forward" })() then
            return true
          end
          if cmp.is_menu_visible() then
            return cmp.select_and_accept()
          end
        end,
        "fallback",
      }
    end,
  },
}
