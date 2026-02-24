require("mason").setup({
	ui = {
		border = "rounded",
	},
})
require("mason-lspconfig").setup({
	automatic_enable = {
		exclude = { "ruby_lsp" },
	},
})
