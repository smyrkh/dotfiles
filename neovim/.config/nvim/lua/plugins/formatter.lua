return {
	{
		'stevearc/conform.nvim',
		lazy = false,
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					astro = { "prettier" },
					css = { "prettier" },
					graphql = { "prettier" },
					html = { "prettier" },
					javascript = { "prettier" },
					json = { "prettier" },
					markdown = { "prettier" },
					scss = { "prettier" },
					tsx = { "prettier" },
					typescript = { "prettier" },
					vue = { "prettier" },
					yaml = { "prettier" },

					c = { "clang-format" },
					cpp = { "clang-format" },
					go = { "goimports", "gofmt" },
					java = { "google-java-format" },
					php = { "php_cs_fixer" },
					python = { "isort", "black" },
					ruby = { "rubocop" },
					rust = { "rustfmt" },

					bash = { "shfmt" },
					zsh = { "shfmt" },
					jq = { "jq" },
					just = { "just" },
					lua = { "stylua" },
					nix = { "alejandra" },
					sql = { "sqlfluff" },
					toml = { "taplo" },
				},
			})
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					local ft = vim.bo[args.buf].filetype

					if ft == "python" then
						require("conform").format({ bufnr = args.buf, formatters = { "isort" } })
					elseif ft == "go" then
						require("conform").format({ bufnr = args.buf, formatters = { "goimports" } })
					end
				end,
			})
		end,
	},
}
