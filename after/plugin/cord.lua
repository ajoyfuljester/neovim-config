local cord = require("cord")

cord.setup({
	display = {
		theme = "catppuccin",
	},
	buttons = {
		{
			label = function(opts)
				if opts.repo_url then
					return 'View Repository'
				end
				return nil
			end,
			url = function(opts)
				return opts.repo_url or nil
			end
		}
	},
	idle = {
		timeout = 180000,
		unidle_on_focus = false,
		details = function(opts)
			local message = "Idling since "
			local delta = os.time() - opts.timestamp
			local seconds = delta % 60
			local minutes = (delta - seconds) / 60
			if minutes >= 60 then
				minutes = minutes % 60
				local hours = (delta - minutes - seconds) / 60 / 60
				message = string.format(message .. "%u:", hours)
			end

			message = string.format(message .. "%u:%02u", minutes, seconds)
			return message
		end,
	},
})
