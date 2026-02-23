-- Set leader key to comma
vim.g.mapleader = ","
--
-- Set runtime paths
vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")
vim.opt.packpath = vim.opt.runtimepath:get()

-- Source existing vimrc if it exists
local vimrc_path = vim.fn.expand("~/.vimrc")
if vim.fn.filereadable(vimrc_path) == 1 then
	vim.cmd("source " .. vimrc_path)
end

-- Plugin management with vim-plug
local Plug = vim.fn["plug#"]

vim.call("plug#begin")

-- Color schemes
-- Plug("jaredgorski/spacecamp") -- spacecamp: Color Scheme
Plug("ellisonleao/gruvbox.nvim") -- Gruvbox: Color Scheme
-- Plug("scottmckendry/cyberdream.nvim") -- cyberdream: Color Scheme
-- Plug("iagorrr/noctis-high-contrast.nvim") -- Noctis High Contrast: Color Scheme
-- Plug("idr4n/andromeda.nvim") -- Andromeda: Color Scheme
--
-- Plug("voylin/godot_color_theme") -- godot Color Scheme
-- Plug("rebelot/kanagawa.nvim") -- kanagawa: Color Scheme
-- Plug("vague2k/vague.nvim") -- Vague: Color Scheme

-- Plugin declarations
Plug("akinsho/toggleterm.nvim") -- terminal integration
Plug("brenoprata10/nvim-highlight-colors") -- highlight color codes
Plug("brianhuster/live-preview.nvim") -- live preview for markdown and other files
Plug("Exafunction/windsurf.nvim") -- windsurf
Plug("giuxtaposition/blink-cmp-copilot") -- blink copilot source
Plug("folke/flash.nvim") -- advanced search
Plug("folke/sidekick.nvim") -- sidekick ai integration
Plug("folke/snacks.nvim") -- multiplug for nvim
Plug("folke/todo-comments.nvim") -- todo comments
Plug("HiPhish/rainbow-delimiters.nvim") -- rainbow delimiters
Plug("igorlfs/nvim-dap-view") -- dap views
Plug("kdheepak/lazygit.nvim") -- lazygit integration
Plug("kevinhwang91/promise-async") -- Required dependency for nvim-ufo
Plug("kevinhwang91/nvim-ufo") -- FOLDIT
Plug("leoluz/nvim-dap-go") -- Go debugging
Plug("lewis6991/gitsigns.nvim") -- git signs in gutter
Plug("linrongbin16/gitlinker.nvim") -- open files or get links to GitHub
Plug("MagicDuck/grug-far.nvim") -- find and replace
Plug("mason-org/mason.nvim") -- LSP/DAP/Linter/Formatter installer
Plug("mason-org/mason-lspconfig.nvim") -- LSP installer
Plug("MeanderingProgrammer/render-markdown.nvim") -- markdown renderer
Plug("mfussenegger/nvim-dap") -- Debug Adapter Protocol
Plug("mfussenegger/nvim-lint") -- Linting framework
Plug("mikavilpas/yazi.nvim") -- yazi tree for nvim
Plug("mg979/vim-visual-multi", { ["branch"] = "master" }) -- multiple cursors
Plug("mrjones2014/smart-splits.nvim") -- split navigation for use with wezterm
Plug("neovim/nvim-lspconfig") -- LSP configuration
Plug("nemanjamalesija/smart-paste.nvim") -- smart paste
Plug("nvim-lua/plenary.nvim") -- Required dependency for yazi.nvim
Plug("nvim-lualine/lualine.nvim") -- better than airline
Plug("nvim-mini/mini.nvim") -- Mini: A collection of minimal, independent Lua modules
-- ig()Plug("nvim-neotest/neotest") -- Neotest: Testing framework
Plug("nvim-neotest/nvim-nio") -- Neotest: Integration with nvim
Plug("nvim-treesitter/nvim-treesitter", { ["branch"] = "main", ["do"] = ":TSUpdate" }) -- Syntax and code analysis
Plug("nvim-treesitter/nvim-treesitter-context") -- show context in treesitter
Plug("nvim-treesitter/nvim-treesitter-textobjects", { ["branch"] = "main" }) -- text object support
Plug("ray-x/go.nvim") -- Go development plugin
Plug("rcarriga/nvim-dap-ui") -- dap ui
Plug("rmagatti/auto-session") -- Session management
Plug("Saghen/blink.cmp") -- blink completion source
Plug("serhez/bento.nvim") -- buffer manager
Plug("stevearc/conform.nvim") -- conform formatter
Plug("theHamsta/nvim-dap-virtual-text") -- dap virtual text
Plug("TheNoeTrevino/haunt.nvim") -- Add buffered comments that are not attached to code
Plug("tpope/vim-dispatch") -- Asynchronous execution
Plug("vim-scripts/SpellCheck") -- Spell checking
Plug("zbirenbaum/copilot.lua") -- copilot lsp

vim.call("plug#end")
require("plugins")

-- Core keymaps (non-plugin specific)
require("core.keymaps")

vim.cmd("set termguicolors")
-- Set default fold method to indent
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99 -- Start with all folds open
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.opt.termguicolors = true
vim.opt.listchars = "tab:▷▷⋮"
vim.wo.relativenumber = true

vim.api.nvim_create_autocmd("FileType", {
	desc = "Ensures tabs are used on Makefiles instead of spaces",
	callback = function(event)
		if event.match == "make" then
			vim.bo.autoindent = false
			vim.bo.expandtab = false
			vim.bo.tabstop = 4
			vim.bo.shiftwidth = 4
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "show the fucking quotes in json files",
	pattern = { "json", "jsonc" },
	callback = function()
		vim.g.indentLine_enabled = 0
	end,
})
