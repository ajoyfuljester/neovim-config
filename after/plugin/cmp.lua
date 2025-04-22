local cmp = require('cmp')

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    completion = {completeopt = 'menu,menuone,noinsert'},
    mapping = {
        ['<C-y>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.confirm({select = false})
            else
                cmp.complete()
            end
        end),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item({behavior = 'select'})
            else
                cmp.complete()
            end
        end),
        ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item({behavior = 'select'})
            else
                cmp.complete()
            end
        end),
    },
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' }
	}),
})
