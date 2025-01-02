return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("tailwind-tools").setup({
      conceal = {
        enabled = true,
      },
      document_color = {
        inline_symbol = "󱓻 ",
      },
    })
  end,
}
