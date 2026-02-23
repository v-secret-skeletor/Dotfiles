require("render-markdown").setup({
	completions = { lsp = { enabled = true } },
})
require("livepreview.config").set({
	picker = require("snacks").picker,
})

vim.keymap.set("n", "<leader>po", ":LivePreview start<CR>", { desc = "Open Markdown Preview" })
vim.keymap.set("n", "<leader>pc", ":LivePreview close<CR>", { desc = "Close Markdown Preview" })
vim.keymap.set("n", "<leader>pp", ":LivePreview pick<CR>", { desc = "Restart Markdown Preview" })
