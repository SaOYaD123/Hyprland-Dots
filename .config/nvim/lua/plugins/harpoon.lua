return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = function()
		local harpoon = require("harpoon")
		local keys = {
			{
				"<leader>h",
				function() end,
				desc = "+harpoon",
			},
			{
				"<leader>ha",
				function()
					harpoon:list():add()
				end,
				desc = "Harpoon File",
			},
			{
				"<leader>hq",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon Quick Menu",
			},
			{
				"<leader>hp",
				function()
					harpoon:list():prev()
				end,
				desc = "Harpoon Go To Previous Buffer",
			},
			{
				"<leader>hn",
				function()
					harpoon:list():next()
				end,
				desc = "Harpoon Go To Next Buffer",
			},
		}

		for i = 1, 5 do
			table.insert(keys, {
				"<leader>h" .. i,
				function()
					require("harpoon"):list():select(i)
				end,
				desc = "Harpoon to File " .. i,
			})
		end

		return keys
	end,
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup({})

		local map = vim.keymap.set

		-- basic telescope configuration
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end

		map("n", "<leader>ht", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Harpoon Open Telescope Window" })
	end,
}
