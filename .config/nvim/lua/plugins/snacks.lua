return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	config = function()
    -- stylua: ignore
    local opts = {
      bigfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      quickfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "p", desc = "Projects", action = ":Telescope project" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[
                                                                                  
                                                                                
                ████ ██████           █████      ██                       
               ███████████             █████                               
               █████████ ███████████████████ ███   ███████████     
              █████████  ███    █████████████ █████ ██████████████     
             █████████ ██████████ █████████ █████ █████ ████ █████     
           ███████████ ███    ███ █████████ █████ █████ ████ █████    
          ██████  █████████████████████ ████ █████ █████ ████ ██████   
                                                                                  
        ]]
        },
      },
    }
		require("snacks").setup(opts)
		local map = vim.keymap.set

		if vim.fn.executable("lazygit") == 1 then
			map("n", "<leader>gg", function()
				Snacks.lazygit()
			end, { desc = "Lazygit (Root Dir)" })
			map("n", "<leader>gG", function()
				Snacks.lazygit()
			end, { desc = "Lazygit (cwd)" })
			map("n", "<leader>gf", function()
				Snacks.lazygit.log_file()
			end, { desc = "Lazygit Current File History" })
			map("n", "<leader>gl", function()
				Snacks.lazygit.log()
			end, { desc = "Lazygit Log" })
			map("n", "<leader>gL", function()
				Snacks.lazygit.log()
			end, { desc = "Lazygit Log (cwd)" })
			map({ "n", "x" }, "<leader>gY", function()
				Snacks.gitbrowse({
					open = function(url)
						vim.fn.setreg("+", url)
					end,
					notify = false,
				})
			end, { desc = "Git Browse (copy)" })
		end
	end,
	keys = {
		{
			"<leader>nn",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
		{
			"<leader>cg",
			function()
				Snacks.lazygit.open()
			end,
			desc = "Lazygit",
		},
	},
}

