
local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()
local mason_lsp = require("mason-lspconfig")
mason_lsp.setup({
	automatic_enable = false,
})

local servers = mason_lsp.get_installed_servers()
for _, server_name in ipairs(servers) do
	vim.lsp.config[server_name] = {
		capabilities = default_capabilities
	}
end

