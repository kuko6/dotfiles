vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- general settings
vim.opt.timeoutlen = 500
vim.opt.updatetime = 1000
vim.opt.mouse = 'n'
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.showmode = true
vim.opt.scrolloff = 5
vim.opt.smartindent = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.winborder = "rounded"
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- tabs and indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- completion
vim.opt.completeopt = {
    'menu',
    'menuone',
    'noselect'
}

-- highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- set softwrap for text files
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
  pattern = {'*.md', '*.typ', '*.txt'},
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true

    -- move by visual line
    vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { buffer = true })
    vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { buffer = true })

    vim.keymap.set({ 'n', 'v' }, '<Down>', 'gj', { buffer = true })
    vim.keymap.set({ 'n', 'v' }, '<Up>', 'gk', { buffer = true })
    vim.keymap.set('i', '<Down>', '<C-o>gj', { buffer = true })
    vim.keymap.set('i', '<Up>', '<C-o>gk', { buffer = true })
  end,
})

 -- remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- trim trailing whitespace
    vim.cmd([[%s/\s\+$//e]])

    -- trim excessive blank lines at end of file
    local last_nonblank = vim.fn.prevnonblank(vim.fn.line('$'))
    if last_nonblank < vim.fn.line('$') then
      vim.api.nvim_buf_set_lines(0, last_nonblank, -1, false, {})
    end
  end,
})
