return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    -- dependencies = { "nvim-mini/mini.icons" },
    config = function()
        require('fzf-lua').setup({'max-perf'})
    end,
    opts = {
        defaults = {
            multiprocess = true
        }
    },
}
