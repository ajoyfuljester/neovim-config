local cord = require("cord")

cord.setup({
	editor = {
		tooltip = "my favorite editor!!!!",
	},
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
			local minutesFormat = "u"
			if minutes >= 60 then
				minutes = minutes % 60
				local hours = (delta - minutes - seconds) / 60 / 60
				message = string.format(message .. "%u:", hours)
				minutesFormat = "02" .. minutesFormat
			end
			minutesFormat = "%" .. minutesFormat

			message = string.format(message .. minutesFormat .. ":%02u", minutes, seconds)
			return message
		end,
	},
})

-- TODO: path to directory be with a dot - instead of `In school`, be `In ./school`
