return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
          "nvim-treesitter/nvim-treesitter-textobjects"
        },
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = { "python", "javascript", "typescript", "bash" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = { query = "@function.outer", desc = "Select around function"},
                            ["if"] = { query = "@function.inner", desc = "Select inside function" },
                            ["ap"] = { query = "@parameter.outer", desc = "Select around parameters" },
                            ["ip"] = { query = "@parameter.inner", desc = "Select inside parameters" }
                        },
                        selection_modes = {
                            ["@parameter.outer"] = "v",
                            ["@function.outer"] = "V"
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer"
                        }
                    }
                }
            })
        end
    },
}
