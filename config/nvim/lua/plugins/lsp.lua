return {
    -- Mason for managing LSP servers
    -- "mason-org/mason.nvim",
    -- "mason-org/mason-lspconfig.nvim",
    -- "neovim/nvim-lspconfig",

    -- Completions
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'enter',
                ["<S-Tab>"] = { "select_prev" },
                ["<Tab>"] = { "select_next" },
            },
            appearance = {
                nerd_font_variant = 'mono'
            },
            signature = { enabled = true },
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 100 },
                ghost_text = { enabled = false },
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
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = false,
                    keymap = {
                        accept = "<M-Tab>",
                    },
                },
                panel = {
                    enabled = false,
                },
            })
        end,
    },
}
