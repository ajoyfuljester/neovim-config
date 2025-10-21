vim.opt.background = 'dark'

vim.cmd.hi('clear')

vim.g.colors_name = 'vibrantcircus'

local colors = {
    {gui = '#dc1e2e', cterm = '160'},
    {gui = '#eb8258', cterm = '173'},
    {gui = '#f6f740', cterm = '227'},
    {gui = '#fff07c', cterm = '228'},
    {gui = '#91e833', cterm = '113'},
    {gui = '#61e786', cterm = '78'},
    {gui = '#4f84ff', cterm = '69'},
    {gui = '#a2d2ff', cterm = '153'},
    {gui = '#bc64f7', cterm = '135'},
    {gui = '#e086d3', cterm = '176'},
    {gui = '#00b594', cterm = '50'},
    {gui = '#00f5d4', cterm = '123'},
    {gui = '#1c1c1c', cterm = '234'},
    {gui = '#282828', cterm = '235'},
    {gui = '#505050', cterm = '253'},
    {gui = '#fafafa', cterm = '231'},
    none = {gui = 'NONE', cterm = 'NONE'}
}

local decorations = {
    undercurl = {gui = 'undercurl', cterm = 'undercurl'},
    bold = {gui = 'bold', cterm = 'bold'},
    underline = {gui = 'underline', cterm = 'underline'},
    italic = {gui = 'italic', cterm = 'italic'},
    inverse = {gui = 'inverse', cterm = 'inverse'},
    none = {gui = 'NONE', cterm = 'NONE'}
}

local function map(t, fun) 
	local new = {}
	for _, v in ipairs(t) do
		table.insert(new, fun(v))
	end
	return new
end

local function hi(group, fg, bg, ...)
    local cmd = ''
    cmd = cmd .. group
    if bg ~= nil then
		if bg['gui'] ~= nil then
			cmd = cmd .. ' guibg=' .. bg['gui']
		end
		if bg['cterm'] ~= nil then
			cmd = cmd .. ' ctermbg=' .. bg['cterm']
		end
    end
    if fg ~= nil then
		if fg['gui'] ~= nil then
			cmd = cmd .. ' guifg=' .. fg['gui']
		end
		if fg['cterm'] ~= nil then
			cmd = cmd .. ' ctermfg=' .. fg['cterm']
		end
    end
	local attrs = {...}
    if #attrs ~= 0 then
		if attrs[1]['gui'] ~= nil then
			cmd = cmd .. ' gui=' .. table.concat(map(attrs, function (a) return a['gui'] end), ",")
		end
		if attrs[1]['cterm'] ~= nil then
			cmd = cmd .. ' cterm=' .. table.concat(map(attrs, function (a) return a['cterm'] end), ",")
		end
	end
    vim.cmd.hi(cmd)
end

local function link(from, to, force)
	if force == nil then
		force = true
	end

    local cmd = 'hi'

    if force then
        cmd = cmd .. '!'
    end
    cmd = cmd .. ' link'
    cmd = cmd .. ' ' .. from
    cmd = cmd .. ' ' .. to
    vim.cmd(cmd)
end


hi('ColorColumn', colors.none, colors[14], decorations.none)
hi('Conceal', colors[11], nil, decorations.italic)
hi('CurSearch', colors[13], colors[7])
hi('Cursor', colors[14], colors[16])
link('lCursor', 'Cursor')
link('CursorIM', 'Cursor')
link('CursorColumn', 'ColorColumn')
link('CursorLine', 'ColorColumn')
hi('Directory', colors[9])
hi('DiffAdd', colors[5], colors.none)
hi('DiffChange', colors[3])
hi('DiffDelete', colors[1])
hi('DiffText', colors[14], colors[3])
link('EndOfBuffer', 'Conceal')
link('TermCursor', 'Cursor')
hi('ErrorMsg', colors[1])
hi('WinSeparator', colors[11], colors[11])
hi('Folded', colors[14], colors[6])
link('FoldColumn', 'Folded')
link('SignColumn', 'LineNr')
link('IncSearch', 'CurSearch')
hi('Substitute', colors[13], colors[7])
hi('LineNr', colors[11], colors[14])
link('LineNrAbove', 'LineNr')
link('LineNrBelow', 'LineNrAbove')
hi('CursorLineNr', colors[13], colors[3], decorations.bold)
link('CursorLineFold', 'Folded')
hi('CursorLineSign', colors[3], colors[14], decorations.bold, decorations.inverse)
hi('MatchParen', colors[14], colors[2])
hi('ModeMsg', colors[13], colors[7], decorations.bold)
hi('MsgArea', colors[16], colors[13])
link('MsgSeparator', 'Cursor')
hi('MoreMsg', colors[8])
link('NonText', 'Conceal')
hi('Normal', colors[16], colors[13])
hi('NormalFloat', colors[16], colors[14])
hi('FloatBorder', colors[7])
link('FloatTitle', 'FloatBorder')
link('FloatFooter', 'FloatBorder')
link('NormalNC', 'Normal')
hi('Pmenu', colors[16], colors[14])
link('PmenuSel', 'Cursor')
link('PmenuKind', 'Pmenu')
link('PmenuKindSel', 'PmenuSel')
hi('PmenuSbar', colors[16], colors[14])
hi('PmenuThumb', colors[14], colors[10])
hi('Question', colors[7])
link('QuickFixLine', 'Question')
hi('Search', colors[14], colors[12])
link('SnippetTabstop', 'Normal')
link('SpecialKey', 'Conceal')
hi('SpellBad', nil, nil, decorations.undercurl)
link('SpellCap', 'SpellBad')
link('SpellLocal', 'SpellBad')
link('SpellRare', 'SpellBad')
hi('StatusLine', colors[13], colors[3], decorations.bold)
hi('StatusLineNC', colors[12], colors[14], decorations.bold)
link('TabLine', 'StatusLineNC')
link('TabLineFill', 'TabLine')
link('TabLineSel', 'StatusLine')
hi('Title', colors['none'], colors['none'])
hi('Visual', nil, colors[15])
link('VisualNOS', 'Visual')
hi('WarningMsg', colors[4])
link('Whitespace', 'Conceal')
hi('WildMenu', colors[4], colors[4])
hi('WinBar', colors[5], colors[5])
link('WinBarNC', 'WinBar')


link('Comment', 'Conceal')
hi('Constant', colors[3])
hi('String', colors[5])
link('Character', 'String')
link('Number', 'Constant')
hi('Boolean', colors[7])
link('Float', 'Number')

hi('Identifier', colors[8])
hi('Function', colors[4])

hi('Statement', colors[8])
link('Conditional', 'Boolean')
hi('Repeat', colors[2])
link('Label', 'Conditional')
link('Operator', 'Normal')
hi('Keyword', colors[10])
hi('Exception', colors[1])

hi('PreProc', colors[3])
link('Include', 'PreProc')
link('Define', 'PreProc')
link('Macro', 'PreProc')
link('PreCondit', 'PreProc')

hi('Type', colors[6])
link('StorageClass', 'Type')
link('Structure', 'Type')
link('Typedef', 'Type')

hi('Special', colors[9])
link('SpecialChar', 'Special')
link('Tag', 'Special')
link('Delimiter', 'Operator')
hi('SpecialComment', colors[13], colors[8])
hi('Debug', colors[13], colors[16])

hi('Underlined', nil, nil, decorations.underline)

hi('Ignore', colors[6], colors[6])

hi('Error', colors[16], colors[1])

link('Todo', 'SpecialComment')

link('Added', 'DiffAdd')
link('Changed', 'DiffChange')
link('Removed', 'DiffDelete')

link('DiagnosticError', 'ErrorMsg')
link('DiagnosticWarn', 'WarningMsg')
hi('DiagnosticInfo', colors[7])
hi('DiagnosticHint', colors[6])


link('@variable', 'Normal')
hi('@markup.raw.block.vimdoc', colors[6])
hi('@variable.member', colors[8])

hi('@tag.html', colors[7])
link('@tag.delimiter.html', '@tag.html')
hi('@tag.attribute.html', colors[10])

link('@tag.css', '@tag.html')
link('@tag.attribute.css', '@tag.attribute.html')

link('@lsp.type.operator.cpp', 'Keyword')

link('@spell.go', '@strings.go')

