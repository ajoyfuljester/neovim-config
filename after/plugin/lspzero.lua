local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})

  vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename)
end)


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
			root_dir = require('lspconfig').util.root_pattern("deno.json", "deno.jsonc"),
		})
	end,
	ts_ls = function()

		require('lspconfig')['ts_ls'].setup({
			filetypes = { "javascript", "typescript", "html" },  -- Include html to detect <script> tags
			root_dir = require('lspconfig').util.root_pattern("tsconfig.json", ".git", "script.js"),
		})
	end,

  },
})
