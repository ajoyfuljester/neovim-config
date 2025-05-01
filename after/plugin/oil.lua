require('oil').setup({
	default_file_explorer = false,
	view_options = {
		show_hidden = true,
	}
})

vim.keymap.set("n", "-", vim.cmd.Oil, { desc = "open Oil file explorer" })
