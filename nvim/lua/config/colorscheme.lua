require("rose-pine").setup({
    variant = "moon", -- auto, main, moon, or dawn
    dark_variant = "moon", -- main, moon, or dawn

    styles = {
        bold = false,
        italic = false,
        transparency = false,
    },

    highlight_groups = {
        Visual = { bg = "highlight_high", inherit = false },
    },
})

vim.cmd("colorscheme rose-pine")
