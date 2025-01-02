-- This is just for taking screenshots of my code.
-- Sometimes I take it. This plugin is just a wrapper. You need the main silicon
-- cli tool to make it work.
-- === Step 1 ===
-- Go to https://github.com/Aloxaf/silicon and download according to your os. Make
-- sure that you can invoke with `silicon` command.
-- === Step 2 ===
-- You need the silicon folder of this repo. It has the Catppuccin themes.
-- Just move the silicon folder to ~/.config folder. Then run the following command
-- in your shell:
-- ```
-- silicon --build-cache
-- ```
-- Then check if its working by:
-- ```
-- silicon --list-themes
-- ```
-- If you see the catppuccin themes then you can go along.

-- Also, you can delete this file to not use this plugin at all.

return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  main = "nvim-silicon",
  keys = {
    { "<leader>sc", ":Silicon<cr>", desc = "Snapshot Code", mode = "v" },
  },
  config = function()
    local opts = {
      font = "FiraCode Nerd Font=34;Noto Color Emoji=34",
      theme = "Catppuccin Mocha",
      output = "~/Pictures/Screenshots/Code",
      window_title = function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
      end,
    }

    require("nvim-silicon").setup(opts)
    local wk = require("which-key")
    wk.add({
      mode = { "v" },
      { "<leader>s", group = "Silicon" },
      {
        "<leader>sc",
        function()
          require("nvim-silicon").clip()
        end,
        desc = "Copy code screenshot to clipboard",
      },
      {
        "<leader>sf",
        function()
          require("nvim-silicon").file()
        end,
        desc = "Save code screenshot as file",
      },
      {
        "<leader>ss",
        function()
          require("nvim-silicon").shoot()
        end,
        desc = "Create code screenshot",
      },
    })
  end,
}
