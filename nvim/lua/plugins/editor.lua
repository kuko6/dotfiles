return {
    { "rose-pine/neovim", name = "rose-pine" },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {
            scope = {
                enabled = false
                -- show_start = false,
                -- show_end = false,
            },
            indent = {
                char = "│",
                tab_char = "│",
            },
        },
    },
    {
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        opts = {
            delay = 800,
            icons = {
                mappings = false,
            },
        },
    },
    {
        'echasnovski/mini.nvim',
        config = function()
            -- Better Around/Inside textobjects
            require('mini.ai').setup { n_lines = 500 }

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            require('mini.surround').setup()

            require('mini.pairs').setup()

            require('mini.move').setup()

            require('mini.tabline').setup()

            local statusline = require 'mini.statusline'
            statusline.setup()
            statusline.section_location = function()
                return '%2l:%-2v'
            end
        end,
    }
}
