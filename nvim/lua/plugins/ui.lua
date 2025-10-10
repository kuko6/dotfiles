return {
    -- Colorscheme
    { "rose-pine/neovim", name = "rose-pine" },

    -- Indent guides
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

    -- Which-key for keybind hints
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
}
