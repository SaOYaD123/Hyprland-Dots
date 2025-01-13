return {
	{
		"OXY2DEV/markview.nvim",
		lazy = false, -- Recommended

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local markview = require("markview")
			markview.setup({
				filetypes = {
					"markdown",
					"norg",
					"rmd",
					"org",
					"mdx",
					"codecompanion",
				},
			})

			require("markview.extras.editor").setup()
			require("markview.extras.checkboxes").setup()
			require("markview.extras.headings").setup()
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
