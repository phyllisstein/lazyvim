-- Constants shared by the UI specs in lua/plugins/ui/ (and neo-tree). The UI layer is adapted
-- from loctvl842/nvim (BeastVim) and flattened to sit on top of LazyVim; upstream spreads it
-- across plugins/ui.lua, features/heirline/*, config/icons.lua and util/{ui,theme,plugin}.lua.
local M = {}

-- "Pill" statusline sections on a Pmenu-colored background, as in the monokai-pro README
-- screenshot. Upstream ties this to neo-tree being in monokai-pro's `background_clear`; here
-- it's just a switch. Also draws a separator on the bufferline's explorer offset.
M.float = true

M.diagnostic_icons = { error = "", warn = "", info = "", hint = "" }

return M
