if true then return {} end

return {
  {
    "kyazdani42/nvim-tree.lua",
    opts = {
      trash = {
        cmd = "trash",
      },
      ui = {
        confirm = {
          remove = true,
          trash = false,
          default_yes = true,
        },
      },
    },
  },
}
