return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      -- Manual mode doesn't automatically change your cwd, which is annoying for me in neotree.
      manual_mode = true,
    })
  end
}
