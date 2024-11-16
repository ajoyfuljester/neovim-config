local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})

  vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename)
end)

local function findClient(name, arr)
	local id = -1
	if not arr then
		arr = vim.lsp.get_clients()
	end
	for _, client in ipairs(arr) do
		if client.name == name then
			id = client.id
			return id
		end
	end
	return id
end

local function stopTSClient()
	local id = findClient('ts_ls')
	if id ~= -1 then
		vim.lsp.stop_client(id)
	end

end

function HANDLESTOPTSCLIENT()
	local bufnr = vim.api.nvim_get_current_buf()
	local i = findClient('denols', vim.lsp.get_clients({bufnr = bufnr}))
	if i ~= -1 then
		stopTSClient()
	end
end


TSCLIENT = nil
ISTSCLIENTACTIVE = false
function STARTTSCLIENT()
	if findClient('ts_ls') ~= -1 then
		return 1
	end
	require('lspconfig')['ts_ls'].setup({
		filetypes = { "javascript", "typescript", "html" },  -- Include html to detect <script> tags
		root_dir = function(filename, bufnr)
			local dir = filename:match('(.*/)')
			-- Allow files named `script.js`
			if filename:match('script%.js$') then
				return dir
			end

			-- Allow files in the `static/` directory
			if filename:match('/static/') then
				return dir
			end

			-- Prevent attachment for other files
			return nil
		end,
		on_new_config = function(newConfig, _)
			local filepath = vim.fn.expand('%:p')

			if not (filepath:match('/static/') or filepath:match('script%.js$')) then
				newConfig.enabled = false
			end
		end,
		on_attach = function(client, bufnr)
			TSCLIENT = client
		end
	})
	return 0
end


-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'lua_ls', 'ts_ls', 'cssls', 'html', 'pyright', 'denols'},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,

    lua_ls = function()
        require('lspconfig')['lua_ls'].setup({
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                        path = vim.split(package.path, ';')
                    },
                    diagnostics = {
                        globals = {"vim"},
                    },
                    workspace = {
                        library = {vim.env.VIMRUNTIME}
                    }
                }
            }
        })
    end,

	denols = function()
		require('lspconfig')['denols'].setup({
			root_dir = function(filename, bufnr)
				if filename:match('/static/') then
					return nil
				end

				local dir = require('lspconfig').util.root_pattern("deno.json", "deno.jsonc")(filename, bufnr)
				return dir
			end,
		})
	end,
	ts_ls = STARTTSCLIENT,

},
})


-- Autocommand to restart ts_ls if we enter a static file
vim.cmd [[
  augroup RestartTSLS
    autocmd!
    autocmd BufEnter */static/* lua STARTTSCLIENT()
  augroup END
]]

vim.cmd [[
  augroup StopTSLS
    autocmd!
    autocmd BufEnter * lua HANDLESTOPTSCLIENT()
  augroup END
]]
