-- indent-blankline.nvim configuration
return {
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    -- Define the toggle function for indent guides
    local toggle_indent_guides = function()
      local current_state = require("ibl.config").get_config(0).enabled
      require("ibl").setup_buffer(0, { enabled = not current_state })
    end

    -- Set up key mapping for toggling indent guides
    vim.keymap.set("n", "<leader>ug", toggle_indent_guides, { desc = "Toggle Indention Guides" })

    -- Setup indent-blankline
    require("ibl").setup({
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    })
  end,
}
