return {
	"danymat/neogen",
	cmd = "Neogen",
	keys = {
		{
			"<leader>cn",
			function()
				require("neogen").generate()
			end,
			desc = "Generate Annotations (Neogen)",
		},
	},
	opts = {
		-- We use luasnip, see snippets.lua for more information
		snippet_engine = "luasnip",
	},
}
