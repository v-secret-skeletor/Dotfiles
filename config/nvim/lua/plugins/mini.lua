require("mini.ai").setup({
	mappings = {
		goto_left = "<leader>b",
		goto_right = "<leader>n",
	},
})
require("mini.comment").setup()
require("mini.diff").setup({})
require("mini.icons").setup()
require("mini.indentscope").setup()
require("mini.move").setup({
	mappings = {
		left = "H",
		right = "L",
		down = "J",
		up = "K",
	},
})
require("mini.surround").setup()
require("mini.pairs").setup()

vim.keymap.set("n", "<leader>dt", function()
	require("mini.diff").toggle_overlay()
end, { desc = "Mini Diff Toggle" })
