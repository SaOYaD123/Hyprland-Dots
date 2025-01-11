return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"AndreM222/copilot-lualine",
	},
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "catppuccin",
				globalstatus = vim.o.laststatus == 3,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_terminal" } },
			},
			sections = {
				lualine_x = {
					{
						"copilot",
						show_colors = true,
					},
					"encoding",
					"fileformat",
					"filetype",
				},
			},
		})
	end,
}
