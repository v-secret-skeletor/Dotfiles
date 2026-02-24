require("conform").setup({
	formatters_by_ft = {
		-- C/C++ formatting
		c = { "clang-format" },
		cpp = { "clang-format" },
		-- Go formatting and import organization
		go = { "goimports", "gofumpt" },
		-- Java formatting
		java = { "google-java-format" },
		-- JavaScript/TypeScript formatting
		javascript = { "prettierd", "prettier" },
		javascriptreact = { "prettierd", "prettier" },
		-- Prefer jq for strict JSON; fall back to prettier if present
		json = { "jq", "prettierd", "prettier" },
		-- Support JSON with comments
		jsonc = { "prettierd", "prettier" },
		-- Lua formatting
		lua = { "stylua" },
		-- Markdown formatting
		markdown = { "prettierd", "prettier" },
		-- Python formatting with black and isort
		python = { "isort", "black" },
		-- Ruby formatting
		ruby = { "rubocop" },
		-- TypeScript formatting
		typescript = { "prettierd", "prettier" },
		typescriptreact = { "prettierd", "prettier" },
		yaml = { "yamlfmt" },
		yml = { "yamlfmt" },
	},
	formatters = {
		-- Custom goimports configuration for import organization
		goimports = {
			prepend_args = { "-local", "github.com" }, -- Adjust this to your org/project
		},
		-- Custom clang-format configuration
		["clang-format"] = {
			prepend_args = {
				"--style={IndentWidth: 2, ColumnLimit: 100, UseTab: Never, AllowShortFunctionsOnASingleLine: None}",
			},
		},
		-- Prefer project-local bin/rubocop over Mason-installed global
		rubocop = {
			command = function(self, ctx)
				local root = vim.fs.root(ctx.buf, { "Gemfile", ".rubocop.yml" })
				if root then
					local local_cmd = root .. "/bin/rubocop"
					if vim.uv.fs_stat(local_cmd) then
						return local_cmd
					end
				end
				return "rubocop"
			end,
		},
	},
	-- Format on save for specific file types
	format_on_save = function(bufnr)
		-- Disable format_on_save for certain file types or large files
		local filetype = vim.bo[bufnr].filetype
		local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))

		-- Skip formatting for large files (>500KB)
		if file_size > 500000 then
			return nil
		end

		-- Enable auto-format for these languages
		local auto_format_ft = {
			"c",
			"cpp",
			"go",
			"java",
			"javascript",
			"javascriptreact",
			"json",
			"jsonc",
			"lua",
			"python",
			"ruby",
			"typescript",
			"typescriptreact",
			"yaml",
			"yml",
		}

		if vim.tbl_contains(auto_format_ft, filetype) then
			return {
				timeout_ms = 5000,
				lsp_fallback = true,
			}
		end

		return nil
	end,
	notify_on_error = true,
})

-- Manual formatting keybind (works for all file types)
vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer (Conform)" })

-- Go-specific keybind for import organization
vim.keymap.set("n", "<leader>gi", function()
	if vim.bo.filetype == "go" then
		require("conform").format({
			formatters = { "goimports" },
			async = true,
		})
	else
		vim.notify("Go imports organization is only available for Go files", vim.log.levels.WARN)
	end
end, { desc = "Organize Go imports" })

-- Format on save toggle
vim.g.conform_format_on_save = true
vim.keymap.set("n", "<leader>tf", function()
	vim.g.conform_format_on_save = not vim.g.conform_format_on_save
	local status = vim.g.conform_format_on_save and "enabled" or "disabled"
	vim.notify("Format on save " .. status, vim.log.levels.INFO)
end, { desc = "Toggle format on save" })
