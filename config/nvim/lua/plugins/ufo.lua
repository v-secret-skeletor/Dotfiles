-- Helper function to get LSP folding capability
local function get_lsp_fold_provider(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, client in ipairs(clients) do
		if client.server_capabilities.foldingRangeProvider then
			return "lsp"
		end
	end
	return nil
end

require("ufo").setup({
	-- Enhanced provider selector with LSP support
	provider_selector = function(bufnr, filetype, buftype)
		-- Disable folding for non-normal buffers (fixes Gitsigns inline diff conflicts)
		if buftype ~= "" and buftype ~= "acwrite" then
			return ""
		end

		-- Return empty table for certain filetypes to disable folding
		local disabled_ft = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" }
		if vim.tbl_contains(disabled_ft, filetype) then
			return ""
		end

		-- Check if LSP supports folding for this buffer
		local lsp_provider = get_lsp_fold_provider(bufnr)
		if lsp_provider then
			-- For LSP-supported files, use LSP first with treesitter fallback
			return { "lsp", "treesitter" }
		end

		-- Language-specific provider preferences (max 2 providers)
		local ft_providers = {
			go = { "lsp", "treesitter" },
			typescript = { "lsp", "treesitter" },
			typescriptreact = { "lsp", "treesitter" },
			javascript = { "lsp", "treesitter" },
			javascriptreact = { "lsp", "treesitter" },
			ruby = { "lsp", "treesitter" },
			c = { "lsp", "treesitter" },
			cpp = { "lsp", "treesitter" },
			python = { "treesitter", "indent" },
			lua = { "treesitter", "indent" },
			vim = { "treesitter", "indent" },
		}

		return ft_providers[filetype] or { "treesitter", "indent" }
	end,
	-- Preview fold content when hovering
	preview = {
		win_config = {
			border = { "", "─", "", "", "", "─", "", "" },
			winhighlight = "Normal:Folded",
			winblend = 0,
		},
		mappings = {
			scrollU = "<C-u>",
			scrollD = "<C-m>",
			jumpTop = "[",
			jumpBot = "]",
		},
	},
	-- Fold icons and styling
	fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local suffix = (" 󰁂 %d "):format(endLnum - lnum)
		local sufWidth = vim.fn.strdisplaywidth(suffix)
		local targetWidth = width - sufWidth
		local curWidth = 0
		for _, chunk in ipairs(virtText) do
			local chunkText = chunk[1]
			local chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if targetWidth > curWidth + chunkWidth then
				table.insert(newVirtText, chunk)
			else
				chunkText = truncate(chunkText, targetWidth - curWidth)
				local hlGroup = chunk[2]
				table.insert(newVirtText, { chunkText, hlGroup })
				chunkWidth = vim.fn.strdisplaywidth(chunkText)
				-- str width returned from truncate() may less than 2nd argument, need padding
				if curWidth + chunkWidth < targetWidth then
					suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
				end
				break
			end
			curWidth = curWidth + chunkWidth
		end
		table.insert(newVirtText, { suffix, "MoreMsg" })
		return newVirtText
	end,
})
-- LSP-aware fold configuration
-- Enhance LSP capabilities to include folding
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "rounded"
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Auto-refresh folds when LSP provides new folding ranges
local function setup_lsp_fold_refresh()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UfoLspRefresh", {}),
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client and client.server_capabilities.foldingRangeProvider then
				-- Refresh folds when LSP provides new folding ranges
				vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
					buffer = args.buf,
					callback = function()
						-- Small delay to ensure LSP has processed the changes
						vim.defer_fn(function()
							local ok, ufo = pcall(require, "ufo")
							if ok and ufo.refresh then
								ufo.refresh()
							end
						end, 100)
					end,
				})
			end
		end,
	})
end

setup_lsp_fold_refresh()

-- Enhanced folding keymaps with LSP integration
local keymap = vim.keymap.set

-- Standard UFO keymaps
keymap("n", "<leader>zo", require("ufo").openAllFolds, { desc = "Open all folds" })
keymap("n", "<leader>zc", require("ufo").closeAllFolds, { desc = "Close all folds" })
keymap("n", "<leader>zm", require("ufo").closeFoldsWith, { desc = "Close folds with level" })

-- Peek fold mapping (using different key to avoid LSP conflict)
keymap("n", "zp", function()
	require("ufo").peekFoldedLinesUnderCursor()
end, { desc = "Peek fold" })

-- LSP-aware fold navigation
keymap("n", "]z", function()
	require("ufo").goNextClosedFold()
end, { desc = "Go to next closed fold" })

keymap("n", "[z", function()
	require("ufo").goPreviousClosedFold()
end, { desc = "Go to previous closed fold" })

-- Toggle fold under cursor with LSP awareness
keymap("n", "<leader>z", function()
	-- Always toggle the fold (open if closed, close if open)
	vim.cmd("normal! za")
end, { desc = "Toggle fold or peek" })
