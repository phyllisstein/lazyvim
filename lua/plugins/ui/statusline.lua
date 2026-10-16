-- Statusline: heirline in place of LazyVim's lualine. Components are plain heirline tables;
-- `section()` wraps each in padding and, with ui.float, rounded separators.

local ui = require("config.ui")

local SEP = {
  fill = { left = "", right = "" },
  thin = { left = "", right = "" },
}

-- Filetypes whose windows shouldn't change what the statusline reports.
local UI_FILETYPES = {
  "help",
  "packer",
  "neogitstatus",
  "NvimTree",
  "Trouble",
  "lir",
  "Outline",
  "spectre_panel",
  "toggleterm",
  "DressingSelect",
  "neo-tree",
  "neo-tree-popup",
  "",
}


---@return table<string, string?>
local function statusline_colors()
  local function hl(name)
    return vim.api.nvim_get_hl(0, { name = name, link = false })
  end
  local function hex(n)
    return n and string.format("#%06x", n) or nil
  end
  return {
    yellow = hex(hl("String").fg),
    white = hex(hl("Normal").fg),
    red = hex(hl("DiagnosticError").fg),
    orange = hex(hl("DiagnosticWarn").fg),
    blue = hex(hl("DiagnosticHint").fg),
    magenta = hex(hl("Statement").fg),
    green = hex(hl("healthSuccess").fg),
    float_bg = hex(hl("Pmenu").bg),
  }
end

-- Wrap a component in padding and, when ui.float is on, rounded separators.
---@param child table
---@param sep "fill"|"thin"
---@param condition? fun(): boolean
local function section(child, sep, condition)
  local function floating()
    return ui.float
  end
  return {
    condition = condition,
    { provider = " " },
    { condition = floating, provider = SEP[sep].left, hl = { fg = "float_bg" } },
    { hl = { bg = (ui.float and sep == "fill") and "float_bg" or nil }, child },
    { condition = floating, provider = SEP[sep].right, hl = { fg = "float_bg" } },
    { provider = " " },
  }
end

-- gitsigns is disabled by the mini-diff extra, so fall back to asking git (cached per repo).
local git_heads = {}
local function git_head()
  if vim.b.gitsigns_head then
    return vim.b.gitsigns_head
  end
  local root = vim.fs.root(0, ".git")
  if not root then
    return nil
  end
  if git_heads[root] == nil then
    local out = vim.fn.systemlist({ "git", "-C", root, "branch", "--show-current" })
    git_heads[root] = (vim.v.shell_error == 0 and out[1] and out[1] ~= "") and out[1] or false
  end
  return git_heads[root] or nil
end

local Git = section({
  update = { "BufEnter", "FocusGained", "DirChanged" },
  init = function(self)
    self.head = git_head() or "!=vcs"
  end,
  hl = { fg = "green" },
  { provider = "  ", hl = { fg = "white" } },
  {
    provider = function(self)
      return self.head
    end,
    hl = { bold = true },
  },
}, "fill")

local function diagnostic_count(severity, icon, color, trailing)
  return {
    provider = function(self)
      return icon .. " " .. self.counts[severity] .. trailing
    end,
    hl = { fg = color },
  }
end

local Diagnostics = section({
  update = { "DiagnosticChanged", "BufEnter" },
  init = function(self)
    local counts = { 0, 0, 0, 0 }
    for _, d in ipairs(vim.diagnostic.get(0)) do
      counts[d.severity] = counts[d.severity] + 1
    end
    self.counts = counts
  end,
  diagnostic_count(vim.diagnostic.severity.ERROR, ui.diagnostic_icons.error, "red", " "),
  diagnostic_count(vim.diagnostic.severity.WARN, ui.diagnostic_icons.warn, "yellow", " "),
  diagnostic_count(vim.diagnostic.severity.INFO, ui.diagnostic_icons.info, "blue", " "),
  diagnostic_count(vim.diagnostic.severity.HINT, ui.diagnostic_icons.hint, "green", ""),
}, "thin")

-- Upstream polls blink.cmp AI sources; with copilot-native, Copilot is an LSP client instead.
local Copilot = section({
  update = { "LspAttach", "LspDetach", "BufEnter", "ModeChanged" },
  provider = " ",
  hl = function()
    local ic = vim.lsp.inline_completion
    local enabled = not ic or ic.is_enabled({ bufnr = 0 })
    local dim = vim.api.nvim_get_hl(0, { name = "LazyButton", link = false }).bg
    return { fg = enabled and "#FEFFFF" or (dim and string.format("#%06x", dim)) }
  end,
}, "fill", function()
  return #vim.lsp.get_clients({ name = "copilot", bufnr = 0 }) > 0
end)

local last_pos
local Position = section({
  update = { "CursorMoved", "CursorMovedI", "BufEnter" },
  init = function(self)
    if not vim.tbl_contains(UI_FILETYPES, vim.bo.filetype) then
      last_pos = { line = vim.fn.line("."), col = vim.fn.col(".") }
    end
    self.text = "Ln " .. last_pos.line .. ", Col " .. last_pos.col
  end,
  provider = function(self)
    return self.text
  end,
  hl = { fg = "magenta" },
}, "fill", function()
  return last_pos ~= nil or not vim.tbl_contains(UI_FILETYPES, vim.bo.filetype)
end)

local last_ft = ""
local FileType = section({
  provider = function()
    local ft = vim.bo.filetype
    if ft == "TelescopePrompt" then
      return ""
    elseif vim.tbl_contains(UI_FILETYPES, ft) then
      ft = last_ft
    else
      last_ft = ft
    end
    return ft:sub(1, 1):upper() .. ft:sub(2)
  end,
  hl = { fg = "blue" },
}, "fill")

local ShiftWidth = section({
  provider = function()
    return "Spaces: " .. vim.bo.shiftwidth
  end,
  hl = { fg = "yellow" },
}, "fill")

local MODE_NAMES = {
  ["n"] = "NORMAL",
  ["no"] = "O-PENDING",
  ["nov"] = "O-PENDING",
  ["noV"] = "O-PENDING",
  ["no\22"] = "O-PENDING",
  ["niI"] = "NORMAL",
  ["niR"] = "NORMAL",
  ["niV"] = "NORMAL",
  ["nt"] = "NORMAL",
  ["ntT"] = "NORMAL",
  ["v"] = "VISUAL",
  ["vs"] = "VISUAL",
  ["V"] = "V-LINE",
  ["Vs"] = "V-LINE",
  ["\22"] = "V-BLOCK",
  ["\22s"] = "V-BLOCK",
  ["s"] = "SELECT",
  ["S"] = "S-LINE",
  ["\19"] = "S-BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["ix"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rc"] = "REPLACE",
  ["Rx"] = "REPLACE",
  ["Rv"] = "V-REPLACE",
  ["Rvc"] = "V-REPLACE",
  ["Rvx"] = "V-REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "EX",
  ["ce"] = "EX",
  ["r"] = "REPLACE",
  ["rm"] = "MORE",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}

-- Keyed by vim.fn.mode() (short form). "cyan"/"purple" aren't in the palette, so they fall
-- through to Neovim's named colors.
local MODE_COLORS = {
  n = "red",
  i = "green",
  v = "blue",
  V = "blue",
  ["\22"] = "cyan",
  c = "orange",
  s = "purple",
  S = "purple",
  ["\19"] = "purple",
  R = "orange",
  r = "orange",
  ["!"] = "red",
  t = "green",
}

local Mode = section({
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  provider = function(self)
    return "%2(" .. (MODE_NAMES[self.mode] or self.mode) .. "%)"
  end,
  hl = function()
    local mode = require("heirline.conditions").is_active() and vim.fn.mode() or "n"
    return { fg = MODE_COLORS[mode], bold = true }
  end,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
}, "fill")

return {
  -- heirline replaces LazyVim's lualine
  { "nvim-lualine/lualine.nvim", enabled = false },

  {
    "rebelot/heirline.nvim",
    event = { "VimEnter", "BufReadPost", "BufNewFile" },
    config = function()
      local conditions = require("heirline.conditions")
      require("heirline").setup({
        statusline = {
          hl = function()
            if not conditions.is_active() then
              return "StatusLineNC"
            end
            return ui.float and "Normal" or "StatusLine"
          end,
          Git,
          Diagnostics,
          { provider = "%=" },
          Copilot,
          Position,
          FileType,
          ShiftWidth,
          Mode,
        },
        opts = { colors = statusline_colors() },
      })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("user_heirline", { clear = true }),
        callback = function()
          require("heirline.utils").on_colorscheme(statusline_colors())
        end,
      })
      vim.api.nvim_create_autocmd("FocusGained", {
        group = "user_heirline",
        callback = function()
          git_heads = {}
        end,
      })
    end,
  },
}
