return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = "3rd/image.nvim",
    ft = { "markdown", "norg", "rmd", "org", "codecompanion", "mdx", "snacks_notif" },
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown", "norg", "rmd", "org", "mdx", "codecompanion", "snacks_notif" },
        code = {
          sign = false,
          width = "block",
          right_pad = 1,
        },
        heading = {
          sign = false,
          icons = {},
        },
      })
    end,
  },
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    opts = {},
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
  },
}
