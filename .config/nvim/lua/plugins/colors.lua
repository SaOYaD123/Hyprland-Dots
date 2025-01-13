return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	keys = {
		{ "<leader>ce", "<cmd>ColorizerToggle<CR>", desc = "Toggle colorizer" },
	},
	opts = {
		filetypes = {},
	},
}
