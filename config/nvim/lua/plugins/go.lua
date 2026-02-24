require("go").setup({
	-- Disable features that overlap with your LSP setup
	lsp_cfg = false, -- Don't configure LSP (you have comprehensive lsp.lua)
	lsp_gofumpt = false, -- Don't configure gofumpt via LSP (conform handles formatting)
	lsp_on_attach = false, -- Don't override your LSP on_attach

	-- Enable useful Go-specific features
	tag_transform = false, -- Don't auto-transform struct tags

	-- Debugging
	dap_debug = false, -- Enable DAP integration if vimspector isn't sufficient
	dap_debug_gui = false, -- Use text-based debugging interface

	-- Code generation and refactoring
	textobjects = false, -- Disable Go-specific text objects (interferes with visual mode)
	test_efm = true, -- Better error formatting for tests

	-- Diagnostic and linting (complementary to LSP)
	lsp_diag_hdlr = false, -- Let your LSP handle diagnostics

	-- Coverage
	coverage = {
		sign = "▎",
		sign_covered = "▎",
	},
})
