require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		"prettierd",
		"eslint_d",
		"herb-ls",
		"gopls",
		"ts-ls",
		"erb-formatter",
		"ruby-lsp",
		"rubocop",
		"sorbet",
	},
	auto_update = true,
	run_on_start = true,
})
