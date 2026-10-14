-- Start screen: snacks dashboard keys, colored by the Dashboard* groups in monokai-pro.lua.

return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          -- stylua: ignore
          keys = {
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')", icon_hl = "DashboardRecent", key_hl = "DashboardRecent" },
            { icon = " ", key = "s", desc = "Last Session", section = "session", icon_hl = "DashboardSession", key_hl = "DashboardSession" },
            { icon = " ", key = "i", desc = "Configuration", action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })", icon_hl = "DashboardConfiguration", key_hl = "DashboardConfiguration" },
            { icon = "󰤄 ", key = "l", desc = "Lazy", action = ":Lazy", icon_hl = "DashboardLazy", key_hl = "DashboardLazy" },
            { icon = " ", key = "m", desc = "Mason", action = ":Mason", icon_hl = "DashboardServer", key_hl = "DashboardServer" },
            { icon = " ", key = "q", desc = "Quit Neovim", action = ":qa", icon_hl = "DashboardQuit", key_hl = "DashboardQuit" },
          },
        },
      },
    },
  },
}
