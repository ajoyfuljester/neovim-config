local telescope = require('telescope')

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-p>"] = "move_selection_next",
				["<C-n>"] = "move_selection_previous",
			}
		}
	}
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<A-e>', builtin.find_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ")})
end)
