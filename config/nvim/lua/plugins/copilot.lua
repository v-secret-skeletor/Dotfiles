-- require("copilot-lsp").setup()
require("copilot").setup({
	nes = {
		enabled = false,
	},
	filetypes = {
		markdown = true,
	},
	suggestion = {
		enabled = false,
		auto_trigger = true,
		debounce = 75,
		keymap = {
			accept = "<C-a>",
			accept_word = false,
			accept_line = false,
			next = "<C-`>",
			dismiss = "<C-;>",
		},
	},
	panel = {
		enabled = false,
	},
	silent_notify = true,
})
require("blink-cmp-copilot")
