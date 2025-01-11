return {
	{
		"mireq/luasnip-snippets",
		dependencies = { "L3MON4D3/LuaSnip" },
		init = function()
			-- Mandatory setup function
			require("luasnip_snippets.common.snip_utils").setup()
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
		enabled = true,
		version = "*",
		dependencies = {
			"mireq/luasnip-snippets",
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = { vim.fn.stdpath("config") .. "/snippets" },
					})
				end,
			},
		},
		opts = function(_, opts)
			local ls = require("luasnip")

			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node
			local f = ls.function_node

			local function clipboard()
				return vim.fn.getreg("+")
			end

			vim.keymap.set({ "i", "s" }, "<Tab>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				else
					vim.api.nvim_input("<C-V><Tab>")
				end
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
				ls.jump(-1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true })

			-- luasnip_snippets config

			local load_ft_func = require("luasnip_snippets.common.snip_utils").load_ft_func
			local ft_func = require("luasnip_snippets.common.snip_utils").ft_func
			local history = true
			local delete_check_events = "TextChanged"

			table.insert(opts, load_ft_func)
			table.insert(opts, ft_func)
			table.insert(opts, history)
			table.insert(opts, delete_check_events)

			-- Custom snippets
			-- the "all" after ls.add_snippets("all" is the filetype, you can know a
			-- file filetype with :set ft
			-- Custom snippets

			-- #####################################################################
			--                            Markdown
			-- #####################################################################

			-- Helper function to create code block snippets
			local function create_code_block_snippet(lang)
				return s({
					trig = lang,
					name = "Codeblock",
					desc = lang .. " codeblock",
				}, {
					t({ "```" .. lang, "" }),
					i(1),
					t({ "", "```" }),
				})
			end

			-- Define languages for code blocks
			local languages = {
				"txt",
				"lua",
				"sql",
				"go",
				"regex",
				"bash",
				"markdown",
				"markdown_inline",
				"yaml",
				"json",
				"jsonc",
				"cpp",
				"csv",
				"java",
				"javascript",
				"python",
				"dockerfile",
				"html",
				"css",
				"templ",
				"php",
			}

			-- Generate snippets for all languages
			local snippets = {}

			for _, lang in ipairs(languages) do
				table.insert(snippets, create_code_block_snippet(lang))
			end

			table.insert(
				snippets,
				s({
					trig = "chirpy",
					name = "Disable markdownlint and prettier for chirpy",
					desc = "Disable markdownlint and prettier for chirpy",
				}, {
					t({
						" ",
						"<!-- markdownlint-disable -->",
						"<!-- prettier-ignore-start -->",
						" ",
						"<!-- tip=green, info=blue, warning=yellow, danger=red -->",
						" ",
						"> ",
					}),
					i(1),
					t({
						"",
						"{: .prompt-",
					}),
					-- In case you want to add a default value "tip" here, but I'm having
					-- issues with autosave
					-- i(2, "tip"),
					i(2),
					t({
						" }",
						" ",
						"<!-- prettier-ignore-end -->",
						"<!-- markdownlint-restore -->",
					}),
				})
			)

			table.insert(
				snippets,
				s({
					trig = "markdownlint",
					name = "Add markdownlint disable and restore headings",
					desc = "Add markdownlint disable and restore headings",
				}, {
					t({
						" ",
						"<!-- markdownlint-disable -->",
						" ",
						"> ",
					}),
					i(1),
					t({
						" ",
						" ",
						"<!-- markdownlint-restore -->",
					}),
				})
			)

			table.insert(
				snippets,
				s({
					trig = "prettierignore",
					name = "Add prettier ignore start and end headings",
					desc = "Add prettier ignore start and end headings",
				}, {
					t({
						" ",
						"<!-- prettier-ignore-start -->",
						" ",
						"> ",
					}),
					i(1),
					t({
						" ",
						" ",
						"<!-- prettier-ignore-end -->",
					}),
				})
			)

			table.insert(
				snippets,
				s({
					trig = "linkt",
					name = 'Add this -> [](){:target="_blank"}',
					desc = 'Add this -> [](){:target="_blank"}',
				}, {
					t("["),
					i(1),
					t("]("),
					i(2),
					t('){:target="_blank"}'),
				})
			)

			table.insert(
				snippets,
				s({
					trig = "todo",
					name = "Add TODO: item",
					desc = "Add TODO: item",
				}, {
					t("<!-- TODO: "),
					i(1),
					t(" -->"),
				})
			)

			-- Paste clipboard contents in link section, move cursor to ()
			table.insert(
				snippets,
				s({
					trig = "linkclip",
					name = "Paste clipboard as .md link",
					desc = "Paste clipboard as .md link",
				}, {
					t("["),
					i(1),
					t("]("),
					f(clipboard, {}),
					t(")"),
				})
			)

			ls.add_snippets("markdown", snippets)

			return opts
		end,
	},
}
