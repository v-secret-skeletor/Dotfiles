vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
require("auto-session").setup({
	log_level = "error",
	auto_save = true,
	auto_create = true,
	args_allow_files_autosave = true,
	close_filetypes_on_save = { "checkhealth", "sidekick_terminal", "grug-far", "toggleterm" },
	allowed_dirs = { "/Users/v-secret-skeletor/Code/*", "/Users/v-secret-skeletor/.config/*" },
	session_lens = {
		picker = "snacks",
		load_on_setup = true,
		mappings = {
			-- add mapping to use flash
		},
	},
	pre_save_cmds = {
		-- function(session_name)
		-- 	-- if a toggletree buffer is open run ToggleTree before close
		-- 	if vim.fn.bufnr("toggleterm") > 0 then
		-- 		vim.cmd("ToggleTerm")
		-- 	end
		-- end,
	},
})

vim.keymap.set("n", "<leader>sl", ":AutoSession search<CR>", { desc = "Session Picker" })
vim.keymap.set("n", "<leader>ss", ":AutoSession save<CR>", { desc = "Save session" })
