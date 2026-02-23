require("haunt").setup({})

vim.keymap.set("n", "<leader>ha", "<cmd>HauntAnnotate<cr>", { desc = "Haunt" })
vim.keymap.set("n", "<leader>hd", "<cmd>HauntDelete<cr>", { desc = "Haunt Delete" })
vim.keymap.set("n", "<leader>hc", "<cmd>HauntClearAll<cr>", { desc = "Haunt Clear All" })
vim.keymap.set("n", "<leader>hl", "<cmd>HauntList<cr>", { desc = "Haunt List" })
vim.keymap.set("n", "<leader>hn", "<cmd>HauntNext<cr>", { desc = "Haunt Next" })
vim.keymap.set("n", "<leader>hm", "<cmd>HauntPrev<cr>", { desc = "Haunt Prev" })

vim.api.nvim_create_autocmd("DirChanged", {
	callback = function()
		local project_bookmarks = vim.fn.getcwd() .. "/.bookmarks/"
		require("haunt.api").change_data_dir(project_bookmarks)
	end,
})
