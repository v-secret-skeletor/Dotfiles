-- require("nio")
local dap = require("dap")
local dapui = require("dap-view")
-- local dapui = require("dapui")
-- dapui.setup()
require("nvim-dap-virtual-text").setup({
	enabled = true,
	enabled_commands = true,
	highlight_changed_variables = true,
	highlight_new_as_changed = false,
	show_stop_reason = true,
	commented = false,
	only_first_definition = true,
	all_references = false,
	filter_references_pattern = "<module",
	virt_text_pos = "eol",
	all_frames = false,
	virt_lines = false,
	virt_text_win_col = nil,
})

require("dap-go").setup()

dap.listeners.after.event_initialized["dapui_config "] = function()
	dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

dap.adapters.delve = function(callback, config)
	if config.mode == "remote" and config.request == "attach" then
		callback({
			type = "server",
			host = config.host or "127.0.0.1",
			port = config.port or "38697",
		})
	else
		callback({
			type = "server",
			port = "${port}",
			executable = {
				command = "dlv",
				args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
				detached = vim.fn.has("win32") == 0,
			},
		})
	end
end

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
	{
		type = "delve",
		name = "Debug",
		request = "launch",
		program = "${file}",
	},
	{
		type = "delve",
		name = "Debug test", -- configuration for debugging test files
		request = "launch",
		mode = "test",
		program = "${file}",
	},
	-- works with go.mod packages and sub packages
	{
		type = "delve",
		name = "Debug test (go.mod)",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	},
}

-- TypeScript/JavaScript debugging with js-debug-adapter
dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "js-debug-adapter",
		args = { "${port}" },
	},
}

dap.configurations.typescript = {
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
	},
	{
		type = "pwa-node",
		request = "launch",
		name = "Debug Jest Tests",
		runtimeExecutable = "node",
		runtimeArgs = {
			"./node_modules/jest/bin/jest.js",
			"--runInBand",
		},
		rootPath = "${workspaceFolder}",
		cwd = "${workspaceFolder}",
		console = "integratedTerminal",
	},
	{
		type = "pwa-node",
		request = "attach",
		name = "Attach",
		processId = require("dap.utils").pick_process,
		cwd = "${workspaceFolder}",
	},
}

dap.configurations.javascript = {
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		cwd = "${workspaceFolder}",
	},
	{
		type = "pwa-node",
		request = "attach",
		name = "Attach",
		processId = require("dap.utils").pick_process,
		cwd = "${workspaceFolder}",
	},
}

vim.keymap.set("n", "<F9>", ":DapNew<CR>", { desc = "DAP Open" })

vim.keymap.set("n", "<F5>", function()
	dap.continue()
end, { desc = "DAP Continue" })

vim.keymap.set("n", "<F10>", function()
	dap.step_over()
end, { desc = "DAP Step Over" })

vim.keymap.set("n", "<F4>", function()
	dap.step_into()
end, { desc = "DAP Step Into" })

vim.keymap.set("n", "<F3>", function()
	dap.step_out()
end, { desc = "DAP Step Out" })

vim.keymap.set("n", "<Leader>bp", function()
	dap.toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })

vim.keymap.set("n", "<Leader>lp", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)

vim.keymap.set("n", "<Leader>bc", function()
	dap.clear_breakpoints()
end, { desc = "DAP Clear Breakpoints" })

vim.keymap.set("n", "<Leader>dr", function()
	dap.repl.open()
end)

vim.keymap.set("n", "<Leader>dl", function()
	dap.run_last()
end)

vim.keymap.set("n", "<F11>", function()
	dapui.toggle()
end, { desc = "DAP UI Toggle", silent = true })
-- vim.keymap.set("n", "<Leader>w",", "<Leader>W", function()
-- 	dapui.close()
-- end)

vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "🛑", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define("DapBreakpointCondition", {
	text = "🟡",
	texthl = "DapBreakpointCondition",
	linehl = "DapBreakpointCondition",
	numhl = "DapBreakpointCondition",
})
vim.fn.sign_define(
	"DapLogPoint",
	{ text = "📖", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define(
	"DapStopped",
	{ text = "➡️", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
)
vim.fn.sign_define("DapBreakpointRejected", {
	text = "❌",
	texthl = "DapBreakpointRejected",
	linehl = "DapBreakpointRejected",
	numhl = "DapBreakpointRejected",
})
