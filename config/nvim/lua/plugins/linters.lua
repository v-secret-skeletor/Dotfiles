require("lint").linters_by_ft = {
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
