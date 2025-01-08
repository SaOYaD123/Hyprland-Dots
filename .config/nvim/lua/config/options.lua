-- options.lua

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.termguicolors = true

-- Enable auto write
vim.o.autowrite = true

-- Sync with system clipboard, only if not in an SSH session
vim.o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

vim.g.loaded_perl_provider = 0

-- Completion options
vim.o.completeopt = "menu,menuone,noselect"

-- Hide * markup for bold and italic
vim.o.conceallevel = 2

-- Confirm to save changes before exiting modified buffer
vim.o.confirm = true

-- Enable highlighting of the current line
vim.o.cursorline = true

-- Use spaces instead of tabs
vim.o.expandtab = true

-- Set fold level
vim.o.foldlevel = 99

-- Format options
vim.o.formatoptions = "jcroqlnt"

-- Grep format and program
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.grepprg = "rg --vimgrep"

-- Ignore case in search patterns
vim.o.ignorecase = true

-- Preview incremental substitute
vim.o.inccommand = "nosplit"

-- Jump options
vim.o.jumpoptions = "view"

-- Global statusline
vim.o.laststatus = 3

-- Wrap lines at convenient points
vim.o.linebreak = true

-- Show some invisible characters (tabs, etc.)
vim.o.list = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Print line number
vim.o.number = true

-- Popup blend
vim.o.pumblend = 10

-- Maximum number of entries in a popup
vim.o.pumheight = 10

-- Relative line numbers
vim.o.relativenumber = false

-- Lines of context
vim.o.scrolloff = 4

-- Round indent
vim.o.shiftround = true

-- Size of an indent
vim.o.shiftwidth = 2

-- Don't show mode since we have a statusline
vim.o.showmode = false

-- Columns of context
vim.o.sidescrolloff = 8

-- Always show the signcolumn
vim.o.signcolumn = "yes"

-- Don't ignore case with capitals
vim.o.smartcase = true

-- Insert indents automatically
vim.o.smartindent = true

-- Put new windows below current
vim.o.splitbelow = true

-- Split keep
vim.o.splitkeep = "screen"

-- Put new windows right of current
vim.o.splitright = true

-- Tab stop
vim.o.tabstop = 2

-- Timeout length
vim.o.timeoutlen = vim.g.vscode and 1000 or 300

-- Enable undo file
vim.o.undofile = true

-- Undo levels
vim.o.undolevels = 10000

-- Update time
vim.o.updatetime = 200

-- Virtual edit
vim.o.virtualedit = "block"

-- Command-line completion mode
vim.o.wildmode = "longest:full,full"

-- Minimum window width
vim.o.winminwidth = 5

-- Disable line wrap
vim.o.wrap = false

-- Smooth scroll for Neovim 0.10+
if vim.fn.has("nvim-0.10") == 1 then
	vim.o.smoothscroll = true
	vim.o.foldexpr = "v:lua.require'utils'.ui.foldexpr()"
	vim.o.foldmethod = "expr"
	vim.o.foldtext = ""
else
	vim.o.foldmethod = "indent"
	vim.o.foldtext = "v:lua.require'utils'.ui.foldtext()"
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
