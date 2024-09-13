vim.g.mapleader = " "

vim.keymap.set("n", "<C-e>", vim.cmd.Ex)
vim.keymap.set({"n", "v"}, "<C-v>", '"*p')
vim.keymap.set({"n", "v"}, "<C-c>", '"*y')
vim.keymap.set("n", "<leader>t", '<cmd>tabnew<CR>')

vim.keymap.set("n", "<leader>v", "<cmd>normal! <C-v><CR>")

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<leader>cd", function()
    vim.cmd.cd('%:h')
    vim.cmd('Git pull --rebase')
end)

local function parseText(text)
    vim.api.nvim_echo(
    {{table.concat(text, '\n')}},
    false,
    {})
end

vim.keymap.set("n", "<leader>l", function() parseText(vim.fn.getreg('l', 1, 1)) end)

local function runWithRedir(cmds)
    vim.cmd.redir('@l')
    for i = 1, #cmds do
        vim.cmd(cmds[i])
    end
    vim.cmd.redir('END')
end


local dirMap = {
    ['colors'] = {'colors %s', {'name'}},
}

local extensionMap = {
    ['py'] = {'!python %s', {'fullPath'}},
    ['pyw'] = {'!python %s', {'fullPath'}},
    ['html'] = {'!start firefox file://%s', {'fullPath'}, true},
}

local function parseArgs(args, map)
	local parsedArgs = {}
	for i = 1, #args do
		table.insert(parsedArgs, map[args[i]])
	end
	return parsedArgs
end

vim.keymap.set("n", "<leader>ee", function()
    -- local path = vim.fn.shellescape(vim.fn.expand('%'))

    local cmd = ''
    local infoMap = {
        ['fullName'] = vim.fn.expand('%:t'),
        ['extension'] = vim.fn.expand('%:e'),
        ['dirPath'] = vim.fn.expand('%:h'),
        ['fullPath'] = vim.fn.expand('%:p'),

    }
    infoMap['name'] = string.sub(infoMap['fullName'], 1, #infoMap['fullName'] - #infoMap['extension'] - 1)

    local dirs = {}
    for m in string.gmatch(infoMap['dirPath'], '%a+') do
        table.insert(dirs, m)
    end
    local dir = dirs[#dirs]

    local matchedDir = dirMap[dir]
    local matchedExtension = extensionMap[infoMap['extension']]

    if matchedDir ~= nil then
        cmd = cmd .. string.format(matchedDir[1], unpack(parseArgs(matchedDir[2], infoMap)))
        runWithRedir({cmd})
    elseif matchedExtension ~= nil then
		if matchedExtension[3] then
			cmd = cmd .. 'silent '
		end
        cmd = cmd .. string.format(matchedExtension[1], unpack(parseArgs(matchedExtension[2], infoMap)))
        runWithRedir({cmd})
    else
        local debug = ''
        for k, v in pairs(infoMap) do
            debug = debug .. k .. ' = ' .. v .. '\n'
        end
        vim.api.nvim_echo({{debug}}, true, {})
    end
end)

local programNames = {
    'main',
    'index',
}

vim.keymap.set("n", "<leader>eE", function()
    local fullFileNames = vim.fn.split(vim.fn.expand('*'), '\n')
    local files = {}

    for i = 1, #fullFileNames do
        local n = string.match(fullFileNames[i], '.*%.')
        if n ~= nil then
            table.insert(files, {string.sub(n, 1, #n - 1), string.sub(fullFileNames[i], #n + 1)})
        else
            table.insert(files, {fullFileNames[i], nil})
        end
    end

    local found = nil
    for i = 1, #programNames do
        for j = 1, #files do
            if programNames[i] == files[j][1] then
                found = files[j]
                break
            end
        end
        if found ~= nil then
            break
        end
    end

    if found ~= nil then
		local infoMap = {
			['fullName'] = found[1] .. '.' .. found[2],
			['extension'] = found[2],
			['dirPath'] = vim.fn.getcwd(),
			['fullPath'] = string.gsub(vim.fn.getcwd(), '\\', '/') .. '/' .. found[1] .. '.' .. found[2],

		}
		infoMap['name'] = string.sub(infoMap['fullName'], 1, #infoMap['fullName'] - #infoMap['extension'] - 1)

		local matchedExtension = extensionMap[found[2]]
		local cmd = ''
		if matchedExtension[3] then
			cmd = cmd .. 'silent '
		end
        cmd = cmd .. string.format(matchedExtension[1], unpack(parseArgs(matchedExtension[2], infoMap)))
        runWithRedir({cmd})
    else
        print('No files matched!')
    end

end)
