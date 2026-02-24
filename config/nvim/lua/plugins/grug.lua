require("grug-far").setup({
	showCompactInputs = true,
	windowCreationCommand = "",
	keymaps = {
		help = "g?",
		replace = "<c-a>",
		syncAll = ",s",
		syncLine = ",l",
		syncNext = ",n",
		syncPrev = ",p",
		syncFile = ",v",
		historyOpen = ",h",
		historyAdd = ",hp",
		refresh = ",r",
		gotoLocation = "<enter>",
		openLocation = ",o",
		openNext = "<down>",
		openPrev = "<up>",
		applyNext = ",j",
		applyPrev = ",k",
		quickfix = ",q",
		abort = ",b",
		close = ",c",
		swapEngine = ",e",
		toggleShowSearchCommand = ",w",
		preview = ",i",
		swapReplacementInterpreter = ",x",
		nextInput = "<tab>",
		prevInput = "<s-tab>",
	},
})

vim.g.maplocalleader = ","
vim.keymap.set("n", "<leader>fr", ":GrugFar<CR>", { desc = "Find and Replace" })
