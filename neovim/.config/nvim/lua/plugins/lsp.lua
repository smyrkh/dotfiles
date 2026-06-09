return {
	{
		'neovim/nvim-lspconfig',
		lazy = false,
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'hrsh7th/cmp-nvim-lsp',
		},
		config = function()
			local autocmd = vim.api.nvim_create_autocmd
			local augroup = vim.api.nvim_create_augroup

			require('mason').setup()
			require('mason-lspconfig').setup({
				ensure_installed = {
				},
			})

			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			local servers = {
				astro = 'astro-ls',
				cssls = 'css-languageserver',
				eslint = 'vscode-eslint-language-server',
				graphql = 'graphql-lsp',
				html = 'html-languageserver',
				jsonls = 'vscode-json-languageserver',
				ts_ls = 'typescript-language-server',
				volar = 'vue-language-server',
				yamlls = 'yaml-language-server',

				clangd = 'clangd',
				gopls = 'gopls',
				intelephense = 'intelephense',
				jdtls = 'jdtls',
				julials = 'julia',
				kotlin_language_server = 'kotlin-language-server',
				pylsp = 'pylsp',
				ruby_lsp = 'ruby-lsp',
				rust_analyzer = 'rust-analyzer',
				sqlls = 'sql-language-server',

				awk_ls = 'awk-language-server',
				bashls = 'bash-language-server',
				cmake = 'cmake-language-server',
				dockerls = 'docker-langserver',
				groovyls = 'groovy-language-server',
				lemminx = 'lemminx',
				lua_ls = 'lua-language-server',
				marksman = 'marksman',
				nil_ls = 'nil',
				taplo = 'taplo',
				vimls = 'vim-language-server',
			}
			for server_name, cmd in pairs(servers) do
				if vim.fn.executable(cmd) == 1 then
					vim.lsp.config(server_name, {
						capabilities = capabilities,
					})
					vim.lsp.enable(server_name)
				end
			end

			local h = require('helpers.map')
			h.nmap('<leader>e', vim.diagnostic.open_float)
			h.nmap('<leader>l', vim.diagnostic.setloclist)
			autocmd('LspAttach', {
				group = augroup('UserLspConfig', { clear = true }),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
					local opts = { buffer = ev.buf }

					h.nmap('K', vim.lsp.buf.hover, opts)
					h.nmap('gD', vim.lsp.buf.declaration, opts)
					h.nmap('gd', vim.lsp.buf.definition, opts)
					h.nmap('gi', vim.lsp.buf.implementation, opts)
					h.nmap('gr', vim.lsp.buf.references, opts)
					h.nmap('<space>wa', vim.lsp.buf.add_workspace_folder, opts)
					h.nmap('<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
					h.nmap('<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
					h.nmap('<space>D', vim.lsp.buf.type_definition, opts)
					h.nmap('<space>rn', vim.lsp.buf.rename, opts)
					h.nmap('<space>ca', vim.lsp.buf.code_action, opts)
					h.vmap('<space>ca', vim.lsp.buf.code_action, opts)
					h.nmap('<space>f', function() require("conform").format({ async = true }) end, opts)
				end,
			})

			autocmd('BufWritePre', {
				group = augroup('LspAutoImport', { clear = true }),
				pattern = { "*.go", "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.astro" },
				callback = function(args)
					local params = vim.lsp.util.make_range_params()
					params.context = { only = { 'source.organizeImports' } }
					local result = vim.lsp.buf_request_sync(args.buf, 'textDocument/codeAction', params, 3000)
					for cid, res in pairs(result or {}) do
						for _, r in pairs(res.result or {}) do
							if r.edit then
								local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
								vim.lsp.util.apply_workspace_edit(r.edit, enc)
							end
						end
					end
				end,
			})
		end,
	},
}
