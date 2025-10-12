return {
    -- Mason for managing LSP servers
    -- "mason-org/mason.nvim",
    -- "mason-org/mason-lspconfig.nvim",
    -- "neovim/nvim-lspconfig",

    -- Completion engine
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = { preset = 'enter' },
            appearance = {
                nerd_font_variant = 'mono'
            },
            signature = { enabled = true },
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 100 },
                ghost_text = { enabled = true },
                accept = {
                    auto_brackets = { enabled = true },
                },
                menu = {
                    draw = { treesitter = { 'lsp' } },
                },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" }
    },
}
