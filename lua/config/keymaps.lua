-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- :InspectLine — every extmark on the cursor's line, with its highlight groups. Covers what
-- :Inspect can't reach because it takes up no buffer position: inlay hints, diagnostic virtual
-- text, blame text, virtual lines, signs. Each piece of virtual text is echoed in its own
-- highlight, so you can see which entry is which.
vim.api.nvim_create_user_command("InspectLine", function()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local ns_names = {}
  for name, id in pairs(vim.api.nvim_get_namespaces()) do
    ns_names[id] = name
  end

  local function groups(hl)
    return type(hl) == "table" and table.concat(hl, "+") or tostring(hl or "Normal")
  end

  local out = {}
  local function put(text, hl)
    out[#out + 1] = { text, hl }
  end

  local marks = vim.api.nvim_buf_get_extmarks(0, -1, { row, 0 }, { row, -1 }, { details = true })
  for _, mark in ipairs(marks) do
    local col, d = mark[3], mark[4]
    local parts = {}
    for _, chunk in ipairs(d.virt_text or {}) do
      parts[#parts + 1] = { chunk[1], groups(chunk[2]) }
    end
    if d.hl_group then
      parts[#parts + 1] = { ("hl_group=%s → col %s"):format(groups(d.hl_group), d.end_col or "?"), nil }
    end
    if d.sign_text then
      parts[#parts + 1] = { d.sign_text, d.sign_hl_group or "SignColumn" }
    end
    if d.line_hl_group then
      parts[#parts + 1] = { "line_hl_group=" .. d.line_hl_group, nil }
    end
    if d.virt_lines then
      parts[#parts + 1] = { ("%d virtual line(s)"):format(#d.virt_lines), nil }
    end
    if #parts > 0 then
      put(("col %-4d %-28s "):format(col, ns_names[d.ns_id] or ("ns " .. d.ns_id)), "Comment")
      for _, p in ipairs(parts) do
        put(p[1], p[2])
        if p[2] then
          put((" (%s)"):format(p[2]), "Comment")
        end
        put("  ")
      end
      put("\n")
    end
  end

  if #out == 0 then
    put("No decorations on this line.", "Comment")
  end
  vim.api.nvim_echo(out, true, {})
end, { desc = "List every extmark (virtual text, signs, highlights) on the cursor line" })
vim.keymap.set("n", "<leader>uX", "<cmd>InspectLine<cr>", { desc = "Inspect Line (extmarks)" })
