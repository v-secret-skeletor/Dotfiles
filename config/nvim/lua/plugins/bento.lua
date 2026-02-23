require("bento").setup({
	max_open_buffers = 30,
	map_last_accessed = true,

	ui = {
		floating = {
			border = "single",
			position = "middle-left",
		},
	},
	actions = {
		vsplit = {
			key = "v",
		},
		split = {
			key = "h",
		},
		copy_path = {
			key = "y",
			action = function(_, buf_name)
				vim.fn.setreg("+", buf_name)
			end,
		},
	},
})
