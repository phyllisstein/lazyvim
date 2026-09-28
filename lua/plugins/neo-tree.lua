return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons"
        },
        enabled = false,
        lazy = false, -- neo-tree will lazily load itself
        opts = {
            close_if_last_window = false,
            enable_diagnostics = false,
            filesystem = {
                follow_current_file = {
                    enabled = true,
                },
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = true,
                },
            },
            sources = {
                "filesystem",
            },
            git_status_scope_to_path = true,
            sort_case_insensitive = true,
            default_component_configs = {
                indent = {
                    with_expanders = true,
                },
                icon = {
                    folder_closed = "",
                    folder_open = "",
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
            },
        },
    },
}
