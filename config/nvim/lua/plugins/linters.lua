local lint = require("lint")

lint.linters_by_ft = {
	cpp = { "cpplint" },
	go = { "golangci_lint" },
	lua = { "luacheck" },
	python = { "flake8" },
	rust = { "clippy" },
	ruby = { "rubocop" },
	javascript = { "eslint" },
	typescript = { "eslint" },
	toml = { "tombi" },
	json = { "jsonlint" },
}

-- Prefer project-local bin/rubocop over Mason-installed global
lint.linters.rubocop.cmd = function()
	local root = vim.fs.root(0, { "Gemfile", ".rubocop.yml" })
	if root then
		local local_cmd = root .. "/bin/rubocop"
		if vim.uv.fs_stat(local_cmd) then
			return local_cmd
		end
	end
	return "rubocop"
end
