return {
  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "nvzone/volt",
    lazy = true,
  },
  {
    "nvzone/minty",
    cmd = { "Shades", "Huefy" },
  },
  {
    "nvzone/menu",
    config = function()
      vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
        vim.cmd.exec('"normal! \\<RightMouse>"')

        local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
        require("menu").open(options, { mouse = true })
      end, {})
    end,
  },
  { "nvzone/timerly", cmd = "TimerlyToggle" },
  { "nvzone/typr" },
  { "nvzone/showkeys", cmd = "ShowkeysToggle" }
}
