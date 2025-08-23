-- Highlight when yanking (copying) text
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
    vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { buffer = true })
    vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { buffer = true })

    vim.keymap.set({ 'n', 'v' }, '<Down>', 'gj', { buffer = true })
    vim.keymap.set({ 'n', 'v' }, '<Up>', 'gk', { buffer = true })
    vim.keymap.set('i', '<Down>', '<C-o>gj', { buffer = true })
    vim.keymap.set('i', '<Up>', '<C-o>gk', { buffer = true })
  end,
})
