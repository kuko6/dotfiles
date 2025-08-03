vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'x' }, 'cp', '"+y', { desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'x' }, 'cv', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set('n', ',', ':noh<cr>', { desc = 'Hide highlights' })
vim.keymap.set("n", "<leader>ee", vim.cmd.Ex, { desc = 'Open netrw' })
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })

-- telescope keybinds
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Open file picker' })
vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Search with grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Open buffer picker' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Open help tags' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Open diagnostics picker' })
vim.keymap.set('n', '<leader>fg', builtin.git_status, { desc = 'Open changed / diff picker' })
vim.keymap.set('n', '<leader>?', builtin.keymaps, { desc = 'Show keymaps' })

-- lsp keybinds
local opts = { noremap = true, silent = true }
local map = function(mode, keys, func, desc)
    vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = desc })
end

map('n', '<leader>d', vim.diagnostic.open_float, 'Hover diagnostics')
map('n', '[d', vim.diagnostic.goto_prev, 'Go to prev diagnostic')
map('n', ']d', vim.diagnostic.goto_next, 'Go to next diagnostic')
map('n', '<leader>dd', vim.diagnostic.setloclist, 'Show diagnostics bar')

local gitsigns = require('gitsigns')
map('n', '<leader>hp', gitsigns.preview_hunk, 'Git: Preview hunk')
map('n', '<leader>hi', gitsigns.preview_hunk_inline, 'Git: Preview hunk inline')

map('n', '<leader>hd', gitsigns.diffthis, 'Git: diff')
-- map('n', '<leader>hD', function()
--   gitsigns.diffthis('~')
-- end)

map('n', '<leader>hQ', function() gitsigns.setqflist('all') end, 'Git: Show changes in project')
map('n', '<leader>hq', gitsigns.setqflist, 'Git: Show changes in file')

-- Toggles
map('n', '<leader>tb', gitsigns.toggle_current_line_blame, 'Git: Toggle inline blame')
map('n', '<leader>tw', gitsigns.toggle_word_diff, 'Git: Toggle word diff')

-- Text object
-- map({'o', 'x'}, 'ih', gitsigns.select_hunk)

map = function(mode, keys, func, bufr, desc)
    vim.keymap.set(mode, keys, func, { noremap = true, silent = true, buffer = bufr, desc = desc })
end

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- local bufopts = { noremap = true, silent = true, buffer = bufnr }
    map('n', '<leader>k', vim.lsp.buf.hover, bufnr, 'LSP: Hover under cursor')
    map('n', 'gi', vim.lsp.buf.implementation, bufnr, 'LSP: Go to implementation')
    map('n', 'gd', vim.lsp.buf.definition, bufnr, 'LSP: Go to implementation')
    -- map('n', 'gr', vim.lsp.buf.references, bufnr, 'LSP: Go to references')
    map('n', '<leader>rn', vim.lsp.buf.rename, bufnr, 'LSP: Rename')
    map('n', '<leader>a', vim.lsp.buf.code_action, bufnr, 'LSP: Code action')

    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wl', function()
    -- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<leader>=", function()
        vim.lsp.buf.format({ async = true })
    end, { noremap = true, silent = true, buffer = bufnr, desc = 'LSP: Format' })
end

return {
    on_attach = on_attach,
}
