local parser_plugins = {}

if ((vim.fn.executable('gcc') == 1) or (vim.fn.executable('clang') == 1))
	and (vim.fn.executable('tree-sitter') == 1) then

	table.insert(parser_plugins, {
		'nvim-treesitter/nvim-treesitter',
		branch = 'main',
		lazy = false,
		build = ':TSUpdate',
		config = function()
			local ensure_installed = {
				'astro',
				'awk',
				'bash',
				'c',
				'cmake',
				'cpp',
				'css',
				'csv',
				'diff',
				'disassembly',
				'dockerfile',
				'git_config',
				'git_rebase',
				'gitattributes',
				'gitcommit',
				'gitignore',
				'go',
				'gomod',
				'gosum',
				'graphql',
				'groovy',
				'html',
				'http',
				'java',
				'javadoc',
				'javascript',
				'jq',
				'json',
				'julia',
				'just',
				'kotlin',
				'lua',
				'make',
				'markdown',
				'markdown_inline',
				'mermaid',
				'nginx',
				'nix',
				'php',
				'phpdoc',
				'powershell',
				'python',
				'regex',
				'requirements',
				'ruby',
				'rust',
				'scss',
				'sql',
				'ssh_config',
				'strace',
				'toml',
				'tsv',
				'tsx',
				'typescript',
				'vim',
				'vimdoc',
				'vue',
				'xml',
				'yaml',
				'zsh',
			}
			require('nvim-treesitter').install(ensure_installed)

			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
				pattern = '*',
				callback = function(args)
					local buf = args.buf
					local ok = pcall(vim.treesitter.start, buf)
					if ok then
						vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	})
else
	vim.schedule(function()
		vim.api.nvim_echo({
			{ "nvim-treesitter: command not found: gcc or clang or tree-sitter", "Comment" },
		}, true, {})
	end)
end

return parser_plugins
