return {
	{

		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"cssls",
					"dockerls",
					"docker_compose_language_service",
					"eslint",
					"emmet_language_server",
					"lua_ls",
					"html",
					"autotools_ls",
					"marksman",
					"pylsp",
					"tailwindcss",
					"yamlls",
					"jsonls",
					"biome",
					"mdx_analyzer",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		opts = function()
			local servers = {
				bashls = {},
				cssls = {},
				dockerls = {},
				docker_compose_language_service = {},
				eslint = {},
				emmet_language_server = {},
				lua_ls = {
					settings = {
						lua_ls = {
							format = {
								enable = false,
							},
						},
					},
				},
				html = {},
				autotools_ls = {},
				marksman = {},
				pylsp = {},
				tailwindcss = {},
				yamlls = {},
				jsonls = {},
				biome = {},
				astro = {},
				dotls = {},
				prismals = {},
				gitlab_ci_ls = {},
				css_variables = {},
				cssmodules_ls = {},
				hyprls = {},
				mdx_analyzer = {},
			}

			return {
				servers = servers,
			}
		end,

		config = function(_, opts)
			for server, config in pairs(opts.servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				require("lspconfig")[server].setup(config)
			end
		end,
	},
	-- Typescript
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("typescript-tools").setup({
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"mdx",
				},
			})
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>ch", "", desc = "+Call Hierarchy" },
			{ "<leader>chi", "<cmd>Lspsaga incoming_calls<cr>", desc = "Incoming Calls" },
			{ "<leader>cho", "<cmd>Lspsaga outgoing_calls<cr>", desc = "Outgoing Calls" },
			{ "<leader>cl", "<cmd>Lspsaga code_action<cr>", desc = "Code Actions" },
			{ "<leader>cd", "", desc = "+definition" },
			{ "<leader>cdp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
			{ "<leader>cdt", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek Type Definition" },
			{ "<leader>cdg", "<cmd>Lspsaga goto_definition<cr>", desc = "Go To Definition" },
			{ "<leader>cdj", "<cmd>Lspsaga peek_definition<cr>", desc = "Go To Type Definition" },
			{ "<leader>ci", "", desc = "+diagnostics" },
			{ "<leader>cij", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Jump To Next Diagnostic" },
			{ "<leader>cip", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Jump To Previous Diagnostic" },
			{ "<leader>cq", "<cmd>Lspsaga finder<cr>", desc = "Finder" },
			{ "<leader>ct", "<cmd>Lspsaga term_toggle<cr>", desc = "Terminal" },
			{ "<leader>co", "<cmd>Lspsaga hover_doc<cr>", desc = "Documentation" },
			{ "<leader>ck", "<cmd>Lspsaga hover_doc ++keep<cr>", desc = "Keep Documentation Pinned" },
			{ "<leader>cr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
		},
		config = function()
			require("lspsaga").setup({
				ui = {
					devicon = true,
				},
				lightbulb = {
					enable = false,
				},
			})
		end,
	},
}
