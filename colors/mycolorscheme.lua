vim.opt.background = 'dark'
vim.g.colors_name = 'cl'

vim.cmd.hi('clear')

local colors = {
    {gui = '#dc1e2e', cterm = '0'},
    {gui = '#eb8258', cterm = '0'},
    {gui = '#f6f740', cterm = '0'},
    {gui = '#fff07c', cterm = '0'},
    {gui = '#91e833', cterm = '0'},
    {gui = '#61e786', cterm = '0'},
    {gui = '#4f84ff', cterm = '0'},
    {gui = '#a2d2ff', cterm = '0'},
    {gui = '#bc64f7', cterm = '0'},
    {gui = '#e086d3', cterm = '0'},
    {gui = '#1c1c1c', cterm = '0'},
    {gui = '#262626', cterm = '0'},
    {gui = '#535353', cterm = '0'},
    {gui = '#c2c2c2', cterm = '0'},
    {gui = '#dee5d9', cterm = '0'},
    {gui = '#faf6ea', cterm = '0'},
    none = {gui = 'NONE', cterm = 'NONE'}
}

local decorations = {
    undercurl = {gui = 'undercurl', cterm = 'undercurl'},
    bold = {gui = 'bold', cterm = 'bold'},
    underline = {gui = 'underline', cterm = 'underline'},
}

local function hi(group, fg, bg, attr)
    local cmd = ''
    cmd = cmd .. group
    if bg ~= nil then
        cmd = cmd .. ' guibg=' .. bg['gui']
        cmd = cmd .. ' ctermbg=' .. bg['cterm']
    end
    if fg ~= nil then
        cmd = cmd .. ' guifg=' .. fg['gui']
        cmd = cmd .. ' ctermfg=' .. fg['cterm']
    end
    if attr ~= nil then
        cmd = cmd .. ' gui=' .. attr['gui']
        cmd = cmd .. ' cterm=' .. attr['cterm']
    end
    vim.cmd.hi(cmd)
end

local function link(from, to, force)
    local cmd = 'hi'
    if force then
        cmd = cmd .. '!'
    end
    cmd = cmd .. ' link'
    cmd = cmd .. ' ' .. from
    cmd = cmd .. ' ' .. to
    vim.cmd(cmd)
end

hi('ColorColumn', nil, colors[12])
hi('Conceal', colors[13])
hi('CurSearch', colors[12], colors[7])
hi('Cursor', colors[12], colors[16])
link('lCursor', 'Cursor', true)
link('CursorIM', 'Cursor')
link('CursorColumn', 'ColorColumn')
link('CursorLine', 'ColorColumn', true)
hi('Directory', colors[9])
hi('DiffAdd', colors[5], colors.none)
hi('DiffChange', colors[3], colors.none)
hi('DiffDelete', colors[1])
hi('DiffText', colors[12], colors[3])
link('EndOfBuffer', 'Conceal')
link('TermCursor', 'Cursor')
hi('ErrorMsg', colors[1])
hi('WinSeparator', colors[8])
hi('Folded', colors[12], colors[6])
link('FoldColumn', 'Folded')
link('SignColumn', 'LineNr')
link('IncSearch', 'CurSearch')
hi('Substitute', colors[15], colors[9])
hi('LineNr', colors[13], colors[12])
link('LineNrAbove', 'LineNr')
link('LineNrBelow', 'LineNr')
hi('CursorLineNr', colors[15], colors[11])
link('CursorLineFold', 'Folded')
link('CursorLineSign', 'CursorLineNr')
hi('MatchParen', colors[12], colors[2])
hi('ModeMsg', colors[12], colors[5])
hi('MsgArea', colors[15], colors[11])
link('MsgSeparator', 'Cursor')
hi('MoreMsg', colors[8])
link('NonText', 'Conceal')
hi('Normal', colors[16], colors[11])
link('NormalFloat', 'Normal', true)
hi('FloatBorder', colors[6])
link('FloatTitle', 'FloatBorder')
link('FloatFooter', 'FloatBorder')
link('NormalNC', 'Normal')
hi('Pmenu', colors[15], colors[12])
link('PmenuSel', 'Cursor')
link('PmenuKind', 'Pmenu')
link('PmenuKindSel', 'PmenuSel')
hi('PmenuSbar', colors[15], colors[13])
hi('PmenuThumb', colors[12], colors[10])
hi('Question', colors[7])
link('QuickFixLine', 'Question', true)
hi('Search', colors[12], colors[4])
hi('SnippetTabstop', colors[1], colors[1])
link('SpecialKey', 'Conceal', true)
hi('SpellBad', nil, nil, decorations.undercurl)
link('SpellCap', 'SpellBad')
link('SpellLocal', 'SpellBad')
link('SpellRare', 'SpellBad')
hi('StatusLine', colors[11], colors[6])
hi('StatusLineNC', colors[14], colors[12])
hi('TabLine', colors[1], colors[1])
link('TabLineFill', 'TabLine')
link('TabLineSel', 'TabLine', true)
hi('Title', colors[7])
hi('Visual', nil, colors[13])
link('VisualNOS', 'Visual')
hi('WarningMsg', colors[4])
link('Whitespace', 'Conceal')
hi('WildMenu', colors[1], colors[1])
hi('WinBar', colors[1], colors[1])
link('WinBarNC', 'WinBar', true)


link('Comment', 'Conceal', true)
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
hi('SpecialComment', colors[11], colors[8])
hi('Debug', colors[11], colors[16])

hi('Underlined', nil, nil, decorations.underline)

hi('Ignore', colors[1], colors[1])

hi('Error', colors[16], colors[1])

link('Todo', 'SpecialComment', true)

link('Added', 'DiffAdd', true)
link('Changed', 'DiffChange', true)
link('Removed', 'DiffDelete', true)




hi('@markup.raw.block.vimdoc', colors[6])
hi('@variable.member', colors[8])
