require("codeium").setup({
	enable_cmp_source = false,
})
require("codeium.virtual_text").status_string()
require("codeium.virtual_text").set_statusbar_refresh(function()
	require("lualine").refresh()
end)
