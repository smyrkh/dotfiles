return {
	{
		'mfussenegger/nvim-lint',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			local lint = require('lint')

			local default_linters = {
				-- astro = { 'eslint' }, --> eslint (lsp)
				css = { 'stylelint' },
				-- graphql = { 'eslint' }, --> eslint (lsp)
				-- html = { 'htmlhint' }, --> html-languageserver (lsp)
				-- javascript = { 'eslint' }, --> eslint (lsp)
				-- json = { 'jsonlint' }, --> jsonls (lsp)
				scss = { 'stylelint' },
				-- tsx = { 'eslint' }, --> eslint (lsp)
				-- typescript = { 'eslint' }, --> eslint (lsp)
				-- vue = { 'eslint' }, --> eslint (lsp)

				-- c = { 'cppcheck' }, --> clangd (lsp)
				-- cpp = { 'cppcheck' }, --> clangd (lsp)
				go = { 'golangci-lint' },
				java = { 'checkstyle' },
				kotlin = { 'ktlint' },
				php = { 'phpcs' },
				python = { 'ruff' },
				ruby = { 'rubocop' },
				-- rust = {}, --> rust-analyzer (lsp)

				bash = { 'shellcheck' },
				cmake = { 'cmakelint' },
				dockerfile = { 'hadolint' },
				-- lua = { 'luacheck' }, --> lua_ls (lsp)
				make = { 'checkmake' },
				markdown = { 'markdownlint' },
				nix = { 'statix' },
				sql = { 'sqlfluff' },
				yaml = { 'yamllint' },
				zsh = { 'zsh' },
			}

			local active_linters = {}
			for ft, linters in pairs(default_linters) do
				local available = {}
				for _, linter_name in ipairs(linters) do
					if vim.fn.executable(linter_name) == 1 then
						table.insert(available, linter_name)
					end
				end
				if #available > 0 then
					active_linters[ft] = available
				end
			end
			lint.linters_by_ft = active_linters

			local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
			vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
