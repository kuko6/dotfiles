-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Set softwrap for text files
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
  pattern = {'*.md', '*.typ', '*.txt'},
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    
    -- Move by visual line
    vim.keymap.set('n', 'j', 'gj', { buffer = true })
    vim.keymap.set('n', 'k', 'gk', { buffer = true })
    vim.keymap.set('v', 'j', 'gj', { buffer = true })
    vim.keymap.set('v', 'k', 'gk', { buffer = true })

    vim.keymap.set('n', '<Down>', 'gj', { buffer = true })
    vim.keymap.set('n', '<Up>', 'gk', { buffer = true })
    vim.keymap.set('i', '<Down>', '<C-o>gj', { buffer = true })
    vim.keymap.set('i', '<Up>', '<C-o>gk', { buffer = true })
    vim.keymap.set('v', '<Down>', 'gj', { buffer = true })
    vim.keymap.set('v', '<Up>', 'gk', { buffer = true })
  end,
})
