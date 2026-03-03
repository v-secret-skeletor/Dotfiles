require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		"prettierd",
		"eslint_d",
		"herb_ls",
		"gopls",
		"ts_ls",
		"erb-formatter",
		"ruby_lsp",
		"rubocop",
		"sorbet",
	},
	auto_update = true,
	run_on_start = true,
})
