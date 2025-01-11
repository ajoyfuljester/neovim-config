local cord = require("cord")

cord.setup({
	buttons = {
		{
			label = function(opts)
				return opts.repo_url and 'View Repository' or 'Website'
			end,
			url = function(opts)
				return opts.repo_url or 'https://example.com'
			end
		}
	}
})
