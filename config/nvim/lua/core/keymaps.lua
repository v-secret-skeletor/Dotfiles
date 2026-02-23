-- Non-plugin keymaps
vim.keymap.set("v", "<c-y>", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader><Tab><Tab>", ":set invlist<CR>", { desc = "show list mode for tabs new lines etc" })

-- Centering movements
vim.keymap.set("n", "G", "Gzz", { desc = "Go to end of file and center" })
vim.keymap.set("n", "gg", "ggzz", { desc = "Go to top of file and center" })
vim.keymap.set("n", "j", "jzz", { desc = "Move down and center" })
vim.keymap.set("n", "k", "kzz", { desc = "Move up and center" })
vim.keymap.set("n", "l", "lzz", { desc = "Move right and center" })
vim.keymap.set("n", "$", "$zz", { desc = "Move to end of line and center" })
vim.keymap.set("n", "_", "_zz", { desc = "Move to beginning of line and center" })

-- bookmarks
-- Delete single bookmark
vim.keymap.set("n", "dm", function()
	local char = vim.fn.nr2char(vim.fn.getchar())
	vim.cmd("delmarks " .. char)
end, { desc = "Delete bookmark" })
-- Delete all bookmarks on current line
vim.keymap.set("n", "dM", function()
	local current_line = vim.fn.line(".")
	local marks = vim.fn.getmarklist(vim.fn.bufnr())
	local to_delete = {}
	for _, mark in ipairs(marks) do
		local mark_char = mark.mark:sub(2, 2)
		if mark.pos[2] == current_line and mark_char:match("[a-zA-Z]") then
			table.insert(to_delete, mark_char)
		end
	end
	if #to_delete > 0 then
		vim.cmd("delmarks " .. table.concat(to_delete, ""))
	end
end, { desc = "Delete bookmarks on current line" })
-- Delete all bookmarks
vim.keymap.set("n", "dMa", function()
	vim.cmd("delmarks!")
end, { desc = "Delete all bookmarks" })

-- Map CTRL C to Escape functionality
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape insert mode" })
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Remove search highlighting" })
vim.keymap.set("v", "<C-c>", "<Esc>", { desc = "Escape visual mode" })
vim.keymap.set("s", "<C-c>", "<Esc>", { desc = "Escape select mode" })

-- Map CTRL S to Escape/Write functionality
vim.keymap.set("i", "<C-s>", "<Esc>:write<CR>", { desc = "Escape insert mode" })
vim.keymap.set("n", "<C-s>", "<Esc>:write<CR>", { desc = "Escape to normal mode" })
vim.keymap.set("v", "<C-s>", "<Esc>:write<CR>", { desc = "Escape visual mode" })

-- map leader i to toggle inlay hints
vim.keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end)

-- GitLinker
vim.keymap.set("n", "<leader>gl", ":GitLink<CR>", { desc = "GitLinker Copy URL" })
vim.keymap.set("v", "<leader>gl", ":GitLink<CR>", { desc = "GitLinker Copy URL" })

-- Copilot Toggle
vim.keymap.set("n", "<leader>ct", ":Copilot toggle<CR>", { desc = "Copilot Toggle" })

--windsurf Toggle
vim.keymap.set("n", "<leader>wt", ":Codeium Toggle<CR>", { desc = "Windsurf Toggle" })

-- Terminal
vim.keymap.set("t", "<C-t>", "<C-\\><C-n>", { desc = "exit terminal insert" })
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function(ev)
		vim.keymap.set("t", "<Del>", function()
			local term_chan = vim.b.terminal_job_id
			if term_chan then
				vim.api.nvim_chan_send(term_chan, "\x04")
			end
		end, { buffer = ev.buf, desc = "Forward delete in terminal" })
	end,
})

vim.keymap.set("n", "<C-q>", ":qall<CR>", { desc = "Close all buffers" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Close buffer" })

vim.keymap.set("n", "<leader>pr", ":! gh pr create --fill<CR>", { desc = "Create PR" })
