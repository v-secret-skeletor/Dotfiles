local flash = require("flash")
flash.setup({
	label = {
		rainbow = {
			enabled = true,
			shade = 1,
		},
	},
	modes = {
		char = {
			enabled = true,
			jump_labels = true,
		},
		search = {
			enabled = true,
		},
	},
})

vim.keymap.set({ "n", "x", "o" }, "S", function()
	flash.treesitter()
end, { desc = "Flash Treesitter" })
