local haunt_sk = require("haunt.sidekick")
require("sidekick").setup({
	nes = {
		enabled = false,
	},
	keys = {
		buffers = { "<c-b>", "buffers", mode = "nt", desc = "open buffer picker" },
		files = { "<c-f>", "files", mode = "nt", desc = "open file picker" },
	},
	cli = {
		prompts = {
			haunt_all = function()
				return haunt_sk.get_locations()
			end,
			haunt_current = function()
				return haunt_sk.get_locations({ current_buffer = true })
			end,
		},
		win = {
			split = {
				width = 0.3,
			},
		},
	},
})

vim.keymap.set("n", "<leader>cc", function()
	require("sidekick.cli").toggle()
end, { desc = "Sidekick toggle" })

vim.keymap.set("v", "<leader>cu", function()
	require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Sidekick send selection" })

vim.keymap.set("n", "<leader>cu", function()
	require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Sidekick send file" })

vim.keymap.set("n", "<leader>cp", function()
	require("sidekick.cli").prompt()
end, { silent = true, desc = "Sidekick prompt" })

vim.keymap.set("n", "<leader>cd", function()
	require("sidekick.cli").close()
end, { silent = true, desc = "Sidekick close" })
