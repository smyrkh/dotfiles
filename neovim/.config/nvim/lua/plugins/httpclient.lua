return {
	{
		'mistweaverco/kulala.nvim',
		lazy = true,
		ft = { 'http' },
		opts = {
			global_keymaps = true,
			global_keymaps_prefix = '<leader>r',
			kulala_keymaps_prefix = "",
			global_keymaps = {
				["Send request <cr>"] = false,
				["Send all requests"] = false,
				["Replay the last request"] = false,
			},
		},
	},
}
