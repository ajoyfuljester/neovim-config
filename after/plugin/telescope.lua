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
vim.keymap.set('n', '<A-e>', builtin.find_files, { desc = "fzf files in current directory" })

vim.keymap.set('n', '<leader>ff', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ")})
end, { desc = "fzf grep directory" })

vim.keymap.set('n', '<leader>fe', builtin.buffers, { desc = "fzf buffers" })
