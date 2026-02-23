-- nvim-treesitter configuration (main branch - modern API)
-- Enable treesitter highlighting and indentation for all filetypes with available parsers
vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable treesitter highlighting and indentation",
	callback = function(args)
		local buf = args.buf
		local max_filesize = 100 * 1024 -- 100 KB

		-- Skip large files
		local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
		if ok and stats and stats.size > max_filesize then
			return
		end

		-- Enable treesitter highlighting (silently fail if no parser available)
		pcall(vim.treesitter.start)
	end,
})

-- Treesitter-based folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Treesitter context
require("treesitter-context").setup({
	enable = true,
	max_lines = 3,
})

-- Treesitter textobjects (main branch API - manual keymaps)
local ts_select = require("nvim-treesitter-textobjects.select")

-- Define textobject keymaps
vim.keymap.set({ "x", "o", "v" }, "a=", function()
	ts_select.select_textobject("@assignment.outer", "textobjects")
end, { desc = "Select outer assignment" })

vim.keymap.set({ "x", "o", "v" }, "i=", function()
	ts_select.select_textobject("@assignment.inner", "textobjects")
end, { desc = "Select inner assignment" })

vim.keymap.set({ "x", "o", "v" }, "l=", function()
	ts_select.select_textobject("@assignment.lhs", "textobjects")
end, { desc = "Select assignment left-hand side" })

vim.keymap.set({ "x", "o", "v" }, "r=", function()
	ts_select.select_textobject("@assignment.rhs", "textobjects")
end, { desc = "Select assignment right-hand side" })

vim.keymap.set({ "x", "o", "v" }, "ac", function()
	ts_select.select_textobject("@class.outer", "textobjects")
end, { desc = "Select outer class" })

vim.keymap.set({ "x", "o", "v" }, "ic", function()
	ts_select.select_textobject("@class.inner", "textobjects")
end, { desc = "Select inner class" })

vim.keymap.set({ "x", "o", "v" }, "ai", function()
	ts_select.select_textobject("@conditional.outer", "textobjects")
end, { desc = "Select outer conditional/block" })

vim.keymap.set({ "x", "o", "v" }, "ii", function()
	ts_select.select_textobject("@conditional.inner", "textobjects")
end, { desc = "Select inner conditional/block" })

vim.keymap.set({ "x", "o", "v" }, "aa", function()
	ts_select.select_textobject("@parameter.outer", "textobjects")
end, { desc = "Select outer parameter" })

vim.keymap.set({ "x", "o", "v" }, "ia", function()
	ts_select.select_textobject("@parameter.inner", "textobjects")
end, { desc = "Select inner parameter" })

vim.keymap.set({ "x", "o", "v" }, "al", function()
	ts_select.select_textobject("@loop.outer", "textobjects")
end, { desc = "Select outer loop" })

vim.keymap.set({ "x", "o", "v" }, "il", function()
	ts_select.select_textobject("@loop.inner", "textobjects")
end, { desc = "Select inner loop" })

vim.keymap.set({ "x", "o", "v" }, "am", function()
	ts_select.select_textobject("@function.outer", "textobjects")
end, { desc = "Select outer method/function" })

vim.keymap.set({ "x", "o", "v" }, "im", function()
	ts_select.select_textobject("@function.inner", "textobjects")
end, { desc = "Select inner method/function" })
