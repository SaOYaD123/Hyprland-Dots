return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        term_colors = true,
        compile = {
          enabled = true,
          path = vim.fn.stdpath("cache") .. "/catppuccin",
        },
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.15,
        },
        styles = {
          comments = { "bold" },
          conditionals = { "bold" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {
          SnacksDashboardHeader = { fg = "#F9E2AE" },
          BlinkCmpMenu = { bg = "#212136", fg = "#cdd6f4" },
          BlinkCmpMenuBorder = { bg = "#1e1e2e", fg = "#585b70" },
          BlinkCmpDoc = { bg = "#212136", fg = "#cdd6f4" },
          BlinkCmpDocBorder = { bg = "#1e1e2e", fg = "#585b70" },
        },
        default_integrations = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = false,
            indentscope_color = "",
          },
          dashboard = true,
          neotree = true,
          blink_cmp = true,
          snacks = true,
        },
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = {
          "catppuccin-mocha",
          "catppuccin-macchiato",
          "catppuccin-frappe",
          "catppuccin-latte",
          "tokyonight-moon",
          "tokyonight-storm",
          "tokyonight-night",
          "tokyonight-day",
        },
      })
    end,
  },
}
