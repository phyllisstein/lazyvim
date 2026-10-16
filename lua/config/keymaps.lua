-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- :InspectLine — every extmark on the cursor's line, with its highlight groups. Covers what
-- :Inspect can't reach because it takes up no buffer position: inlay hints, diagnostic virtual
-- text, blame text, virtual lines, signs. Each group is labeled with the extmark field it sits in,
-- which is the role it plays (they're all ordinary highlight groups):
--   hl_group=X → col N     a stretch of buffer text, up to col N
--   virt_text: "…" (X)     extra text the extmark draws; (none) = no group of its own
--   sign: "…" (X)          the gutter icon (sign_hl_group)
--   line_hl_group=X, number_hl_group=X, …   whole-line, line-number and similar groups
--   virt_lines: N, groups  extra lines drawn below
-- Virtual text and signs are echoed in their own highlight, so you can see which entry is which.
vim.api.nvim_create_user_command("InspectLine", function()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local ns_names = {}
  for name, id in pairs(vim.api.nvim_get_namespaces()) do
    ns_names[id] = name
  end

  local function groups(hl)
    if hl == nil or (type(hl) == "table" and #hl == 0) then
      return nil
    end
    return type(hl) == "table" and table.concat(hl, "+") or tostring(hl)
  end

  local out = {}
  local function put(text, hl)
    out[#out + 1] = { text, hl }
  end
  local function label(text)
    put(text, "Comment")
  end

  local marks = vim.api.nvim_buf_get_extmarks(0, -1, { row, 0 }, { row, -1 }, { details = true })
  for _, mark in ipairs(marks) do
    local col, d = mark[3], mark[4]
    local fields = {} ---@type fun()[] each prints one role
    if d.hl_group then
      fields[#fields + 1] = function()
        label(("hl_group=%s → col %s"):format(groups(d.hl_group), d.end_col or "?"))
      end
    end
    if d.virt_text and #d.virt_text > 0 then
      fields[#fields + 1] = function()
        label(("virt_text(%s): "):format(d.virt_text_pos or "eol"))
        for _, chunk in ipairs(d.virt_text) do
          local g = groups(chunk[2])
          put('"' .. chunk[1] .. '"', g)
          label((" (%s) "):format(g or "none"))
        end
      end
    end
    if d.sign_text then
      fields[#fields + 1] = function()
        label("sign: ")
        put('"' .. d.sign_text .. '"', groups(d.sign_hl_group))
        label((" (%s)"):format(groups(d.sign_hl_group) or "none"))
      end
    end
    -- Any other *_hl_group field (line_hl_group, number_hl_group, cursorline_hl_group, …).
    local others = {}
    for k, v in pairs(d) do
      if k:match("_hl_group$") and k ~= "sign_hl_group" then
        others[#others + 1] = ("%s=%s"):format(k, groups(v) or "none")
      end
    end
    table.sort(others)
    for _, o in ipairs(others) do
      fields[#fields + 1] = function()
        label(o)
      end
    end
    if d.virt_lines and #d.virt_lines > 0 then
      fields[#fields + 1] = function()
        local seen, list = {}, {}
        for _, line in ipairs(d.virt_lines) do
          for _, chunk in ipairs(line) do
            local g = groups(chunk[2]) or "none"
            if not seen[g] then
              seen[g], list[#list + 1] = true, g
            end
          end
        end
        label(("virt_lines: %d, groups %s"):format(#d.virt_lines, table.concat(list, ", ")))
      end
    end

    if #fields > 0 then
      label(("col %-4d %-28s "):format(col, ns_names[d.ns_id] or ("ns " .. d.ns_id)))
      for i, f in ipairs(fields) do
        f()
        if i < #fields then
          label("  │  ")
        end
      end
      put("\n")
    end
  end

  if #out == 0 then
    label("No decorations on this line.")
  end
  vim.api.nvim_echo(out, true, {})
end, { desc = "List every extmark (virtual text, signs, highlights) on the cursor line" })
-- Replaces LazyVim's relative-number toggle, which config/autocmds.lua makes redundant.
vim.keymap.set("n", "<leader>uL", "<cmd>InspectLine<cr>", { desc = "Inspect Line (extmarks)" })
-- Snacks registered its own which-key label for the toggle; replace that too.
local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({ { "<leader>uL", desc = "Inspect Line (extmarks)", icon = { icon = "󰙅 ", color = "cyan" } } })
end
