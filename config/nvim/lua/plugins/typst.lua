return {
    {
        'chomosuke/typst-preview.nvim',
        ft = 'typst',
        version = '1.*',
        opts = {
            debug = false,
            open_cmd = nil,
            invert_colors = 'never',

            -- Whether the preview will follow the cursor in the source file
            follow_cursor = false,

            -- This function will be called to determine the root of the typst project
            get_root = function(path_of_main_file)
                local root = os.getenv 'TYPST_ROOT'
                if root then
                    return root
                end
                return vim.fn.fnamemodify(path_of_main_file, ':p:h')
            end,

            -- This function will be called to determine the main file of the typst
            -- project.
            get_main_file = function(path_of_buffer)
                return path_of_buffer
            end,
        }, -- lazy.nvim will implicitly calls `setup {}`
    }
}
