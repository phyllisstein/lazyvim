-- Completion: nothing accepted by default (Enter is always Enter), one Tab for Copilot ghost text
-- and menu selections, partial ghost-text accept,
-- and no buffer-word suggestions. Ghost-text styling lives in lua/plugins/ui/ghost-text.lua.

local inline = vim.lsp.inline_completion
local inline_ns = vim.api.nvim_create_namespace("nvim.lsp.inline_completion")

-- Hide the ghost text and ignore it until the buffer next changes.
local function dismiss_ghost()
  vim.api.nvim_buf_clear_namespace(0, inline_ns, 0, -1)
  vim.b.ghost_dismissed_at = vim.b.changedtick
end

local function ghost_dismissed()
  return vim.b.ghost_dismissed_at == vim.b.changedtick
end

-- Accept the next word or line of the ghost text, leaving the rest suggested.
-- Copilot re-requests on the cursor move and normally offers the remainder again.
---@param unit "word"|"line"
local function accept_partial(unit)
  if ghost_dismissed() then
    return false
  end
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

      -- Nothing is ever accepted by default, so nothing ever needs a keystroke to ignore:
      -- the menu starts with no item selected, moving through it doesn't insert anything, and
      -- <CR> is always a newline. <C-y> still accepts explicitly (selecting the top item if none).
      opts.completion = opts.completion or {}
      opts.completion.list = vim.tbl_deep_extend("force", opts.completion.list or {}, {
        selection = { preselect = false, auto_insert = false },
      })
      opts.keymap["<CR>"] = { "fallback" }

      -- Moving through the menu dismisses the ghost text, so what's on screen is what <Tab> takes.
      -- Neovim has no public dismiss, so the ghost is cleared and ignored until the next edit
      -- (Copilot re-suggests as you type).
      for key, select in pairs({ ["<Down>"] = "select_next", ["<C-n>"] = "select_next", ["<Up>"] = "select_prev", ["<C-p>"] = "select_prev" }) do
        opts.keymap[key] = {
          function(cmp)
            if cmp.is_menu_visible() then
              dismiss_ghost()
              return cmp[select]()
            end
          end,
          key:match("^<C%-") and "fallback_to_mappings" or "fallback",
        }
      end

      -- <Tab>, in order:
      --   1. the menu item you selected (<C-n>/<Down>)
      --   2. Copilot's ghost text, whole
      --   3. a next-edit suggestion (sidekick), then the next snippet placeholder
      --   4. a literal tab
      opts.keymap["<Tab>"] = {
        function(cmp)
          if cmp.is_menu_visible() and cmp.get_selected_item() then
            return cmp.accept()
          end
          if not ghost_dismissed() and inline.get() then
            return true
          end
          if LazyVim.cmp.map({ "ai_nes", "snippet_forward" })() then
            return true
          end
        end,
        "fallback",
      }
    end,
  },
}
