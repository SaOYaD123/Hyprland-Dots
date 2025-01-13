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
            { icon = " ", key = "p", desc = "Projects", action = ":Telescope projects" },
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
          notify = true,
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
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>Z",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Toggle Zoom",
    },
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
      mode = { "n", "v" },
    },
    {
      "<leader>gb",
      function()
        Snacks.git.blame_line()
      end,
      desc = "Git Blame Line",
    },
    {
      "<leader>cT",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal (Bottom)",
    },
    {
      "<c-_>",
      function()
        Snacks.terminal()
      end,
      desc = "which_key_ignore",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
}






