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
    { "j-hui/fidget.nvim", opts = {} },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({
                "*",
                css = { rgb_fn = true },
            })
        end,
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
            require('mini.ai').setup { n_lines = 500 }
            require('mini.surround').setup()
            require('mini.pairs').setup()
            require('mini.move').setup()
            require('mini.tabline').setup()

            local statusline = require('mini.statusline')
            statusline.setup({
                use_icons = true,
                content = {
                    active = function()
                        local mode, mode_hl = statusline.section_mode({ trunc_width = 70 })
                        local git = statusline.section_git({ trunc_width = 40 })
                        -- local diff = statusline.section_diff({ trunc_width = 80 })
                        local diagnostics = statusline.section_diagnostics({ trunc_width = 70 })
                        -- local lsp = statusline.section_lsp({ trunc_width = 80 })
                        local filename = statusline.section_filename({ trunc_width = 100 })
                        local fileinfo = statusline.section_fileinfo({ trunc_width = 140 })
                        local search = statusline.section_searchcount({ trunc_width = 70 })
                        local location = statusline.section_location({ trunc_width = 70 })

                        return statusline.combine_groups({
                            { hl = mode_hl,                  strings = { mode } },
                            { hl = 'MiniStatuslineDevinfo',  strings = { git } },
                            { hl = 'MiniStatuslineFilename', strings = { filename } },
                            '%=', -- separator
                            { hl = 'MiniStatuslineDevinfo',  strings = { diagnostics } },
                            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo, location } },
                        })
                    end,
                },
            })

            statusline.section_location = function()
                return '%2l:%-2v'
            end
        end,
    }
}
