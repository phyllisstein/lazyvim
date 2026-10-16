-- Neo-tree. Layout and components from loctvl842/nvim (features/neo-tree), merged with the
-- choices already made here (sources, hidden files, git symbols). LazyVim's neo-tree extra
-- supplies the rest (l/h/Y/O/P mappings, rename hooks).

-- Upper-case the root and skip its icon; everything else matches neo-tree's built-ins.
local function name_component(config, node, state)
    local common = require("neo-tree.sources.common.components")
    local highlights = require("neo-tree.ui.highlights")
    if node:get_depth() == 1 and node.type ~= "message" then
        return { text = vim.fn.fnamemodify(node.name, ":p:h:t"):upper() .. " ", highlight = highlights.ROOT_NAME }
    end
    return common.name(config, node, state)
end

local function icon_component(config, node, state)
    if node:get_depth() == 1 then
        return {}
    end
    return require("neo-tree.sources.common.components").icon(config, node, state)
end

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons"
        },
        lazy = false, -- neo-tree will lazily load itself
        init = function()
            -- Hide the cursor inside neo-tree; the cursorline already marks the selection.
            local group = vim.api.nvim_create_augroup("user_neotree_cursor", { clear = true })
            local saved
            local function show()
                if saved then
                    vim.o.guicursor, saved = saved, nil
                end
                vim.cmd("hi Cursor blend=0")
            end
            vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertEnter" }, {
                group = group,
                callback = function()
                    if vim.bo.filetype ~= "neo-tree" then
                        return show()
                    end
                    saved = saved or vim.o.guicursor
                    vim.o.guicursor = "n:block-Cursor"
                    vim.wo.foldcolumn = "0"
                    vim.cmd("hi Cursor blend=100")
                end,
            })
            vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, { group = group, callback = show })
        end,
        opts = {
            close_if_last_window = true,
            popup_border_style = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" },
            async_directory_scan = "always",
            filesystem = {
                follow_current_file = {
                    enabled = true,
                },
                filtered_items = {
                    hide_dotfiles = true,
                    hide_gitignored = true,
                },
                group_empty_dirs = true,
                components = { name = name_component, icon = icon_component },
                window = {
                    mappings = {
                        ["H"] = "navigate_up",
                        ["<bs>"] = "toggle_hidden",
                        ["."] = "set_root",
                        ["/"] = "fuzzy_finder",
                        ["f"] = "filter_on_submit",
                        ["<c-x>"] = "clear_filter",
                        ["a"] = { "add", config = { show_path = "relative" } },
                    },
                },
            },
            sources = {
                "filesystem",
                -- "buffers",
                "git_status",
                "document_symbols",
            },
            source_selector = {
                winbar = true,
                content_layout = "center",
                tabs_layout = "equal",
                show_separator_on_edge = true,
                sources = {
                    { source = "filesystem", display_name = "󰉓 File" },
                    { source = "git_status", display_name = " Git" },
                    { source = "document_symbols", display_name = " Symbols" },
                },
            },
            git_status_scope_to_path = true,
            sort_case_insensitive = true,
            window = {
                width = 40,
                mappings = {
                    ["<1-LeftMouse>"] = "open",
                },
            },
            default_component_configs = {
                indent = {
                    indent_size = 2,
                    padding = 1,
                    with_markers = true,
                    indent_marker = "│",
                    last_indent_marker = "└",
                    with_expanders = true,
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                icon = {
                    folder_closed = "",
                    folder_open = "",
                    folder_empty = "",
                    folder_empty_open = "",
                    default = " ",
                },
                modified = {
                    symbol = "",
                },
                git_status = {
                    symbols = {
                        -- Change type
                        added     = "", -- U+F459
                        deleted   = "",
                        modified  = "",
                        renamed   = "",
                        -- Status type
                        untracked = "",
                        ignored   = "",
                        unstaged  = "",
                        staged    = "",
                        conflict  = "",
                    },
                    align = "right",
                },
                diagnostics = {
                    symbols = require("config.ui").diagnostic_icons,
                },
            },
        },
    },
    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
        },
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
    {
        -- The edgy extra pins one sidebar pane per neo-tree source, which duplicates the source
        -- selector's tabs. Keep a single pane that holds whichever source the selector shows.
        "folke/edgy.nvim",
        optional = true,
        opts = function(_, opts)
            local kept = false
            opts.left = vim.tbl_filter(function(view)
                if view.ft ~= "neo-tree" then
                    return true
                end
                if kept then
                    return false
                end
                kept = true
                view.title = "Neo-Tree"
                view.filter = nil -- any source, so switching tabs keeps the window in the sidebar
                return true
            end, opts.left or {})
        end,
    },
}
