-- General Settings
vim.opt.timeoutlen = 500   -- Time (in ms) to wait for a mapped sequence to complete
vim.opt.updatetime = 1000  -- Faster LSP hover highlights (default is 4000ms)
vim.opt.mouse = 'n'         -- Enable mouse support in all modes
vim.opt.wrap = false       -- Enable line wrapping
vim.opt.breakindent = true -- Indent wrapped lines to match line start
vim.opt.showmode = true    -- Show current mode (like -- INSERT --
vim.opt.scrolloff = 3      -- Minimal number of lines to keep above and below cursor
vim.opt.smartindent = true

vim.opt.number = true     -- Show line numbers
vim.opt.relativenumber = true
vim.opt.hlsearch = true   -- Highlight all search matches
vim.opt.ignorecase = true -- Case-sensitive search (see smartcase)
vim.opt.smartcase = true  -- Override ignorecase if search includes uppercase letters
vim.opt.cursorline = true -- Highlight on which line the cursor is on
vim.opt.winborder = "rounded"
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- Tabs and Indentation
vim.opt.tabstop = 2      -- Number of spaces per tab
vim.opt.shiftwidth = 2   -- Number of spaces for each indentation level
vim.opt.expandtab = true -- Convert tabs to spaces

-- Completion
vim.opt.completeopt = {
    'menu',    -- Show completion menu
    'menuone', -- Show menu even for a single match
    'noselect' -- Don't auto-select any completion item
}

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
