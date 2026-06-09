local h = require('helpers.map')

return {
	{
		'lukas-reineke/indent-blankline.nvim',
		lazy = false,
		config = function()
			local highlight = {
				'CursorColumn',
				'Whitespace',
			}
			require('ibl').setup({
				indent = {
					highlight = highlight,
					char = '',
				},
				whitespace = {
					highlight = highlight,
				},
				scope = {
					enabled = false,
				},
			})
		end,
	},
	{
		"m00qek/baleia.nvim",
		lazy = false,
		config = function()
			vim.g.baleia = require("baleia").setup({})

			-- Command to colorize the current buffer
			vim.api.nvim_create_user_command("BaleiaColorize", function()
				vim.g.baleia.once(vim.api.nvim_get_current_buf())
			end, { bang = true })

			-- Command to show logs
			vim.api.nvim_create_user_command("BaleiaLogs", vim.cmd.messages, { bang = true })
		end,
	},
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		config = function()
			require('nvim-autopairs').setup()

			-- local npairs = require('nvim-autopairs')
			-- -- TODO: bs overwrite bullets.vim bs
			-- npairs.setup({
			-- 	map_bs = false,
			-- })
			-- h.imap('<bs>', npairs.autopairs_bs(), { expr = true, noremap = true, silent = true })

			h.imap('<c-f>', '<c-g>U<right>')
		end,
	},
}
