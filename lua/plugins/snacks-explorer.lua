return {
    "folke/snacks.nvim",
    opts = {
        picker = {
            sources = {
                explorer = {
                    follow_file = true,
                    tree = true,
                    git_status = true,
                    git_status_open = false,
                    git_untracked = true,
                    diagnostics = false,
                    watch = true,
                    hidden = false,
                    ignored = false,
                    layout = { layout = { position = "right" } },
                },
            },
            -- Reference block below is Snacks' own defaults, copied verbatim.
            -- Replace glyphs with your own picks; PragmataPro appears to cover
            -- this whole codepoint range (confirmed: dir/dir_open/file/live/commit).
            icons = {
                files = {
                    enabled = true, -- show file icons
                    dir = "󰉋 ",
                    dir_open = "󰝰 ",
                    file = "󰈔 "
                },
                keymaps = {
                    nowait = "󰓅 "
                },
                tree = {
                    vertical = "│ ",
                    middle   = "├╴",
                    last     = "└╴",
                },
                undo = {
                    saved = " ",
                },
                ui = {
                    live       = "󰐰 ",
                    hidden     = "h",
                    ignored    = "i",
                    follow     = "f",
                    selected   = "● ",
                    unselected = "○ ",
                    -- selected = " ",
                },
                git = {
                    enabled   = true, -- show git icons
                    commit    = "󰜘 ", -- used by git log
                    staged    = "●", -- staged changes. always overrides the type icons
                    added     = "",
                    deleted   = "",
                    ignored   = " ",
                    modified  = "○",
                    renamed   = "",
                    unmerged  = " ",
                    untracked = "?",
                },
                diagnostics = {
                    Error = " ",
                    Warn  = " ",
                    Hint  = " ",
                    Info  = " ",
                },
                lsp = {
                    unavailable = "",
                    enabled = " ",
                    disabled = " ",
                    attached = "󰖩 "
                },
                kinds = {
                    Array         = " ",
                    Boolean       = "󰨙 ",
                    Class         = " ",
                    Color         = " ",
                    Control       = " ",
                    Collapsed     = " ",
                    Constant      = "󰏿 ",
                    Constructor   = " ",
                    Copilot       = " ",
                    Enum          = " ",
                    EnumMember    = " ",
                    Event         = " ",
                    Field         = " ",
                    File          = " ",
                    Folder        = " ",
                    Function      = "󰊕 ",
                    Interface     = " ",
                    Key           = " ",
                    Keyword       = " ",
                    Method        = "󰊕 ",
                    Module        = " ",
                    Namespace     = "󰦮 ",
                    Null          = " ",
                    Number        = "󰎠 ",
                    Object        = " ",
                    Operator      = " ",
                    Package       = " ",
                    Property      = " ",
                    Reference     = " ",
                    Snippet       = "󱄽 ",
                    String        = " ",
                    Struct        = "󰆼 ",
                    Text          = " ",
                    TypeParameter = " ",
                    Unit          = " ",
                    Unknown       = " ",
                    Value         = " ",
                    Variable      = "󰀫 ",
                },
            }
        },
    },
}
