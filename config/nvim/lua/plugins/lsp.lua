-- LSP configuration using Neovim -1.11+ native vim.lsp.config API
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Enable folding capabilities for UFO
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

-- Enhanced diagnostic configuration
vim.diagnostic.config({
	virtual_text = {
		severity = { min = vim.diagnostic.severity.WARN },
		source = "if_many",
		format = function(diagnostic)
			if diagnostic.severity == vim.diagnostic.severity.ERROR then
				return string.format("✗ %s", diagnostic.message)
			elseif diagnostic.severity == vim.diagnostic.severity.WARN then
				return string.format("⚠ %s", diagnostic.message)
			else
				return string.format("ℹ %s", diagnostic.message)
			end
		end,
	},
	signs = {
		severity = { min = vim.diagnostic.severity.HINT },
	},
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
	severity_sort = true,
	update_in_insert = false,
})

-- Set diagnostic signs
local signs = { Error = "✗", Warn = "⚠", Hint = "💡", Info = "ℹ" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Inlay hints if supported
if vim.lsp.inlay_hint then
	vim.lsp.inlay_hint.enable(true)
end

-- Prefer project-local bin/rubocop over Mason-installed global
vim.lsp.config("ruby_lsp", {
	capabilities = capabilities,
	init_options = {
		formatter = "rubocop",
		linters = { "rubocop" },
	},
	before_init = function(params, config)
		local root = config.root_dir
		if root then
			local local_cmd = root .. "/bin/rubocop"
			if vim.uv.fs_stat(local_cmd) then
				params.initializationOptions = vim.tbl_deep_extend("force", params.initializationOptions or {}, {
					rubocop = { command = local_cmd },
				})
			end
		end
	end,
})

local k = vim.keymap.set
local bufopts = { noremap = true, silent = true, buffer = bufnr }

-- Navigation keymaps
k("n", "gD", vim.lsp.buf.declaration, bufopts)
k("n", "gd", vim.lsp.buf.definition, bufopts)
k("n", "gi", vim.lsp.buf.implementation, bufopts)
k("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
k("n", "gr", vim.lsp.buf.references, bufopts)

-- Code actions and refactoring
k("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
k("v", "<leader>ca", vim.lsp.buf.code_action, bufopts)
k("n", "<leader>rn", vim.lsp.buf.rename, bufopts)

-- Diagnostic navigation
k("n", "[d", vim.diagnostic.goto_prev, bufopts)
k("n", "]d", vim.diagnostic.goto_next, bufopts)
k("n", "<leader>e", vim.diagnostic.open_float, bufopts)
k("n", "<leader>q", vim.diagnostic.setloclist, bufopts)

-- Hover and signature help
k("n", "K", vim.lsp.buf.hover, bufopts)
k("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
k("i", "<C-k>", vim.lsp.buf.signature_help, bufopts)

-- Workspace management
k("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
k("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
k("n", "<leader>wl", function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, bufopts)
