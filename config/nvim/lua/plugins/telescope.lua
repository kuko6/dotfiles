return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        config = function()
            require('telescope').setup {
                defaults = {
                    layout_config = {
                        prompt_position = 'top',
                        mirror = false,
                    },
                    sorting_strategy = 'ascending',
                }
            }
            pcall(require('telescope').load_extension, 'fzf')
        end
    },
}
