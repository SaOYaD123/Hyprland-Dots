return {
  "folke/lazydev.nvim",
  ft = "lua",
  cmd = "LazyDev",
  dependencies = { "Bilal2453/luvit-meta", lazy = true },
  opts = {
    library = {
      { path = "luvit-meta/library", words = { "vim%.uv" } },
      { path = "lazy.nvim",          words = { "LazyVim" } },
    },
  },
}
