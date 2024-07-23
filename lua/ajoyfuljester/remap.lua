vim.g.mapleader = " "

vim.keymap.set("n", "<C-e>", vim.cmd.Ex)
vim.keymap.set("n", "<C-v>", '"*p')
vim.keymap.set("i", "<C-v>", '"*p')
vim.keymap.set("n", "<C-c>", '"*y')
vim.keymap.set("v", "<C-c>", '"*y')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>cd", function() vim.cmd.cd('%:h') end)

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
    ['colors'] = {'colors %s', 'name'},
}

local extensionMap = {
    ['py'] = {'!python %s', 'fullPath'},
}
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

    local function extractArgs(rawCMD)
        local args = {}
        for i = 2, #rawCMD do
            table.insert(args, infoMap[rawCMD[i]])
        end
        return args
    end

    local dirs = {}
    for m in string.gmatch(infoMap['dirPath'], '%a+') do
        table.insert(dirs, m)
    end
    local dir = dirs[#dirs]

    local matchedDir = dirMap[dir]
    local matchedExtension = extensionMap[infoMap['extension']]

    if matchedDir ~= nil then
        cmd = string.format(matchedDir[1], unpack(extractArgs(matchedDir)))
        runWithRedir({cmd})
    elseif matchedExtension ~= nil then
        cmd = string.format(matchedExtension[1], unpack(extractArgs(matchedExtension)))
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
        local cmd = string.format(extensionMap[found[2]][1], found[1] .. '.' .. found[2])
        runWithRedir({cmd})
    else
        print('No files matched!')
    end

end)
