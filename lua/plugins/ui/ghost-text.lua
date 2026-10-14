-- Ghost text (LSP inline completion, i.e. Copilot): syntax-highlighted and faded, like VSCode.
--
-- Neovim draws the whole suggestion in one `ComplHint` group and offers no hook to change that,
-- so this intercepts nvim_buf_set_extmark for the inline-completion namespace only. The cursor
-- line plus the suggestion is parsed with Treesitter (so a fragment like `et x = 1` parses as
-- `let x = 1`), and each run of text gets its capture's color blended toward the background.
-- Any failure falls through to Neovim's own rendering.

local FADE = 0.55 -- how much of the syntax color survives (0 = invisible, 1 = real code)

local inline_ns = vim.api.nvim_create_namespace("nvim.lsp.inline_completion")
local groups = {} ---@type table<string, string> capture group -> faded group

local function blend(fg, bg, alpha)
  local function ch(c, shift)
    return bit.band(bit.rshift(c, shift), 0xff)
  end
  local function mix(shift)
    return math.floor(ch(fg, shift) * alpha + ch(bg, shift) * (1 - alpha) + 0.5)
  end
  return mix(16) * 0x10000 + mix(8) * 0x100 + mix(0)
end

local function normal()
  local hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  return hl.fg or 0xffffff, hl.bg or 0x000000
end

---@param capture? string a Treesitter group like "@keyword.lua", or nil for plain text
local function faded(capture)
  local key = capture or "Normal"
  if not groups[key] then
    local fg, bg = normal()
    local hl = capture and vim.api.nvim_get_hl(0, { name = capture, link = false }) or {}
    local name = "GhostText_" .. key:gsub("[^%w]", "_")
    vim.api.nvim_set_hl(0, name, { fg = blend(hl.fg or fg, bg, FADE), italic = true })
    groups[key] = name
  end
  return groups[key]
end

local function set_base_groups()
  groups = {}
  local fg, bg = normal()
  vim.api.nvim_set_hl(0, "ComplHint", { fg = blend(fg, bg, FADE), italic = true })
  vim.api.nvim_set_hl(0, "ComplHintMore", { link = "Comment" })
end

---@return [string, string][]?, [string, string][][]?
local function highlight(buf, row, col, opts)
  local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
  local query = lang and vim.treesitter.query.get(lang, "highlights")
  if not query then
    return
  end

  -- Rebuild the suggestion's lines (Neovim's chunks are one text chunk per line, plus an
  -- optional ComplHintMore "(1/3)" chunk on the last).
  local more
  local texts = { opts.virt_text[1][1] }
  for _, l in ipairs(opts.virt_lines or {}) do
    texts[#texts + 1] = l[1] and l[1][1] or ""
  end
  local last = (opts.virt_lines and #opts.virt_lines > 0) and opts.virt_lines[#opts.virt_lines] or opts.virt_text
  if last[2] and last[2][2] == "ComplHintMore" then
    more = last[2]
  end

  local prefix = (vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""):sub(1, col)
  local lines = vim.deepcopy(texts)
  lines[1] = prefix .. lines[1]
  local src = table.concat(lines, "\n")
  local tree = vim.treesitter.get_string_parser(src, lang):parse()[1]

  local marks = {} ---@type table<integer, table<integer, string>> line -> byte -> group
  for i = 1, #lines do
    marks[i] = {}
  end
  for id, node in query:iter_captures(tree:root(), src, 0, -1) do
    local name = query.captures[id]
    if not name:match("^_") and name ~= "spell" and name ~= "nospell" and name ~= "conceal" then
      local sr, sc, er, ec = node:range()
      for r = sr, er do
        local l = lines[r + 1]
        if l then
          for b = (r == sr and sc or 0) + 1, (r == er and ec or #l) do
            marks[r + 1][b] = "@" .. name .. "." .. lang -- later captures win, as in Neovim
          end
        end
      end
    end
  end

  local function chunks(i, from)
    local out, run, run_group = {}, "", nil
    local l = lines[i]
    for b = from, #l do
      local g = marks[i][b]
      if g ~= run_group and run ~= "" then
        out[#out + 1] = { run, faded(run_group) }
        run = ""
      end
      run, run_group = run .. l:sub(b, b), g
    end
    if run ~= "" or #out == 0 then
      out[#out + 1] = { run, faded(run_group) }
    end
    return out
  end

  local virt_text = chunks(1, #prefix + 1)
  local virt_lines = {}
  for i = 2, #lines do
    virt_lines[#virt_lines + 1] = chunks(i, 1)
  end
  local tail = #virt_lines > 0 and virt_lines[#virt_lines] or virt_text
  if more then
    tail[#tail + 1] = more
  end
  return virt_text, virt_lines
end

-- Keep the original across `:Lazy reload` so the wrapper never stacks.
_G.__ghost_text_set_extmark = _G.__ghost_text_set_extmark or vim.api.nvim_buf_set_extmark
local set_extmark = _G.__ghost_text_set_extmark

vim.api.nvim_buf_set_extmark = function(buf, ns, row, col, opts)
  if ns == inline_ns and opts and opts.virt_text and opts.virt_text[1] then
    local ok, vt, vl = pcall(highlight, buf, row, col, opts)
    if ok and vt then
      opts = vim.tbl_extend("force", opts, { virt_text = vt, virt_lines = vl })
    end
  end
  return set_extmark(buf, ns, row, col, opts)
end

set_base_groups()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("user_ghost_text", { clear = true }),
  callback = set_base_groups,
})

return {}
