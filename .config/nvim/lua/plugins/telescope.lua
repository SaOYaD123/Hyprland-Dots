return {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-ui-select.nvim",
			"ahmedkhalf/project.nvim",
		},
		config = function()
			local image_preview = require("custom.telescope-preview").setup()

			-- Define the function globally to ensure it is accessible for keymaps
			_G.find_nvim_files = function()
				local builtin = require("telescope.builtin")
				builtin.find_files({
					prompt_title = " Neovim Config",
					cwd = "~/.config/nvim", -- Set the directory to search in
					hidden = true, -- Show hidden files, useful in config directories
				})
			end

			local colors = require("catppuccin.palettes").get_palette()

			-- Telescope highlight groups
			local TelescopeColors = {
				-- Matching and Selection
				TelescopeMatching = { fg = colors.peach },
				TelescopeSelection = { fg = colors.text, bg = colors.surface1, bold = true },
				-- Prompt highlights
				TelescopePromptPrefix = { bg = colors.surface1 },
				TelescopePromptNormal = { bg = colors.surface1 },
				TelescopePromptBorder = { bg = colors.surface1, fg = colors.surface1 },
				TelescopePromptTitle = { bg = colors.red, fg = colors.mantle },
				-- Results highlights
				TelescopeResultsNormal = { bg = colors.mantle },
				TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
				TelescopeResultsTitle = { fg = colors.overlay2 },
				-- Preview highlights
				TelescopePreviewNormal = { bg = colors.mantle },
				TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
				TelescopePreviewTitle = { bg = colors.green, fg = colors.crust },
			}

			-- Apply highlights
			for highlight_group, color_settings in pairs(TelescopeColors) do
				vim.api.nvim_set_hl(0, highlight_group, color_settings)
			end

			-- Telescope setup
			require("telescope").setup({
				defaults = {
					file_previewer = image_preview.file_previewer,
					buffer_previewer_maker = image_preview.buffer_previewer_maker,
					prompt_prefix = "   ",
					selection_caret = "➤ ",
					path_display = { "smart" },
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							preview_width = 0.55,
							width = 0.9,
							height = 0.9,
							prompt_position = "top",
						},
						vertical = {
							height = 0.4,
							preview_height = 0.3,
							width = 0.9,
							preview_cutoff = 10,
							prompt_position = "top",
						},
						center = {
							anchor = "N",
							width = 0.9,
							preview_cutoff = 10,
						},
					},
				},
				pickers = {
					find_files = {
						hidden = true,
						-- theme = "dropdown",
					},
					colorscheme = {
						enable_preview = true,
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			-- Keymap setup
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find Files (Telescope)" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep (Telescope)" })
			vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Old Files (Telescope)" })
			vim.api.nvim_set_keymap(
				"n",
				"<leader>fc",
				"<cmd>lua find_nvim_files()<CR>",
				{ noremap = true, silent = true }
			)

			-- Load extensions
			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("noice")
			require("telescope").load_extension("projects")
		end,
	},
}
