if true then return {} end

return {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    opts = {
        terminal_cmd = "~/.local/bin/claude"
    },
    keys = {
        { "<leader>C", nil, desc = "Claude Code", icon = "✻" },
        { "<leader>Cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
        { "<leader>Cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
        { "<leader>Cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
        { "<leader>CC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
        { "<leader>Cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
        { "<leader>Cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
        { "<leader>Cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
        {
            "<leader>Cf",
            "<cmd>ClaudeCodeTreeAdd<cr>",
            desc = "Add file",
            ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
        },
        -- Diff management
        { "<leader>Ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        { "<leader>Cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
}
