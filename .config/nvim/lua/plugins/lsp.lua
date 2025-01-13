return {
	{

		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ui = {
				icons = {
					package_installed = " ",
					package_pending = " ",
					package_uninstalled = " ",
				},
			},
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
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason-lspconfig.nvim",
		},
		opts = function()
			local servers = {
				astro = {},
				bashls = {},
				biome = {},
				cssls = {},
				css_variables = {},
				cssmodules_ls = {},
				docker_compose_language_service = {},
				dockerls = {},
				dotls = {},
				emmet_language_server = {},
				eslint = {},
				hyprls = {},
				jsonls = {},
				lua_ls = {
					settings = {
						lua_ls = {
							format = {
								enable = false,
							},
						},
					},
				},
				markdown_oxide = {},
				marksman = {},
				mdx_analyzer = {},
				prismals = {},
				pylsp = {},
				tailwindcss = {},
				yamlls = {},
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
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
			"lewis6991/gitsigns.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			-- Helper function to check if a directory exists relative to the root of the project
			local function is_installed(dir_name)
				local cwd = vim.fn.getcwd() -- Get the current working directory
				local found = vim.fs.find(dir_name, { path = cwd, upward = true, type = "directory" })
				return not vim.tbl_isempty(found)
			end

			-- Check for Prettier and ESLint installations
			local prettier_installed = is_installed("node_modules/prettier")
			local eslint_installed = is_installed("node_modules/eslint")

			-- Dynamically configure sources based on checks
			local sourcesConfig = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.yamlfmt,
				null_ls.builtins.diagnostics.rubocop,
				null_ls.builtins.formatting.rubocop,
				null_ls.builtins.diagnostics.markdownlint_cli2,
				null_ls.builtins.diagnostics.yamllint,
				null_ls.builtins.formatting.shfmt,
				null_ls.builtins.code_actions.gitsigns,
				null_ls.builtins.completion.spell,
				null_ls.builtins.formatting.biome,
			}

			-- Add Prettierd if Prettier is installed
			if prettier_installed then
				table.insert(sourcesConfig, null_ls.builtins.formatting.prettierd)
			end

			-- Add ESLint diagnostics if ESLint is installed
			if eslint_installed then
				table.insert(sourcesConfig, require("none-ls.diagnostics.eslint_d"))
			end

			-- Setup null-ls
			null_ls.setup({
				sources = sourcesConfig,
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({
							group = augroup,
							buffer = bufnr,
						})
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
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
