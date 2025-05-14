vim.g.mapleader = " "

-- vim.keymap.set("n", "-", vim.cmd.Explorer, { desc = "open netrw file explorer" })
vim.keymap.set({"n", "v"}, "<C-v>", '"+p', { desc = "paste from the `+` register (system clipboard)" })
vim.keymap.set({"n", "v"}, "<C-c>", '"+y', { desc = "copy to the `+` register (system clipboard)" })
vim.keymap.set({"n", "v"}, "<leader>p", '"0p', { desc = "paste from the `0` register" })
vim.keymap.set("n", "<leader>t", '<cmd>tabnew<CR>', { desc = "create a new tab" })

vim.keymap.set("n", "<leader>v", "<cmd>normal! <C-v><CR>", { desc = "copy to system clipboard" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "escape key passthrough in terminal mode" })

vim.keymap.set("n", "<leader>cd", function()
    vim.cmd.cd('%:h')
    vim.cmd('Git pull --rebase')
end, { desc = "change directory into the current file directory and run git pull --rebase, to update the repo if it exists" })

local function parseText(text)
    vim.api.nvim_echo(
		{{
			table.concat(text, '')
		}},
		false,
		{}
	)
end

local outputRegister = 'l'

---@diagnostic disable-next-line: redundant-parameter
vim.keymap.set("n", "<leader>" .. outputRegister , function() parseText(vim.fn.getreg(outputRegister, 1, 1)) end, { desc = "display data in the `outputRegister` register" })

local function runWithRedir(cmds)
	-- print(table.concat(cmds, ', '))
    vim.cmd.redir('@' .. outputRegister)
    for i = 1, #cmds do
        vim.cmd(cmds[i])
    end
    vim.cmd.redir('END')
end


local dirMap = {
    ['colors'] = {'colors %s', {'name'}},
}

local extensionMapExecute = {
    ['py'] = {'!python "%s"', {'path'}},
    ['pyw'] = {'!python "%s"', {'path'}},
    ['html'] = {'!$BROWSER file://%s', {'fullPath'}, true},
    ['js'] = {'!deno run %s', {'path'}},
    ['typ'] = {'!$BROWSER file://%s.pdf', {'fullPathNoExtension'}, true},
    ['cpp'] = {'!./%s', {'name'}},
}

local extensionMapCompile = {
    ['typ'] = {'!typst compile %s', {'path'}},
    ['cpp'] = {'!g++ %s -o %s', {'fullName', 'name'}},
}

local function parseArgs(args, map)
	local parsedArgs = {}
	for i = 1, #args do
		table.insert(parsedArgs, map[args[i]])
	end
	return parsedArgs
end

local executeKeymapFunction = function(actionMap)
    local cmd = ''
    local infoMap = {
        ['fullName'] = vim.fn.expand('%:t'),
        ['extension'] = vim.fn.expand('%:e'),
		['path'] = vim.fn.expand('%'),
        ['dirPath'] = vim.fn.expand('%:h'),
        ['fullPath'] = vim.fn.expand('%:p'),
        ['fullPathNoExtension'] = string.sub(vim.fn.expand('%:p'), 1, -1 * (#vim.fn.expand('%:e') + 1 + 1)),
		['name'] = string.sub(vim.fn.expand('%:r'), #vim.fn.expand('%:h')),

    }

    local dirs = {}
    for m in string.gmatch(infoMap['dirPath'], '%a+') do
        table.insert(dirs, m)
    end
    local dir = dirs[#dirs]

    local matchedDir = dirMap[dir]
    local matchedExtension = actionMap[infoMap['extension']]

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
end

vim.keymap.set("n", "<leader>ee", function()
	executeKeymapFunction(extensionMapExecute)
end, { desc = "execute the current file" })
vim.keymap.set("n", "<leader>ec", function()
	executeKeymapFunction(extensionMapCompile)
end, { desc = "compile the current file" })

local programNames = {
    'main',
    'index',
}

local executeMainKeymapFunction = function(actionMap)
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

		local matchedExtension = actionMap[found[2]]
		local cmd = ''
		if matchedExtension[3] then
			cmd = cmd .. 'silent '
		end
        cmd = cmd .. string.format(matchedExtension[1], unpack(parseArgs(matchedExtension[2], infoMap)))
        runWithRedir({cmd})
    else
        print('No files matched!')
    end

end

vim.keymap.set("n", "<leader>eE", function()
	executeMainKeymapFunction(extensionMapExecute)
end, { desc = "execute the \"main\" file in the directory" })
vim.keymap.set("n", "<leader>eC", function()
	executeMainKeymapFunction(extensionMapCompile)
end, { desc = "compile the \"main\" file in the directory" })


vim.keymap.set("n", "<leader>eD", function()
	local split = 'vsplit'
	local ter = 'ter deno task dev'
	runWithRedir({split, ter})
end, { desc = "open terminal and run deno task dev (for watching)" })

-- TODO: add another variation for watching `<leader>ew`? possibly ditch the `e`

vim.keymap.set("v", "<leader>j", 'Jgqq', { desc = "balance out lines of text" })
