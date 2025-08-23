-- General Settings
vim.opt.timeoutlen = 300   -- Time (in ms) to wait for a mapped sequence to complete
vim.opt.updatetime = 1000  -- Faster LSP hover highlights (default is 4000ms)
vim.opt.mouse = 'a'        -- Enable mouse support in all modes
vim.opt.wrap = false       -- Enable line wrapping
vim.opt.breakindent = true -- Indent wrapped lines to match line start
vim.opt.showmode = true    -- Show current mode (like -- INSERT --
vim.opt.scrolloff = 20     -- Minimal number of lines to keep above and below cursor

-- UI Enhancements
vim.opt.number = true     -- Show line numbers
vim.opt.relativenumber = false
vim.opt.hlsearch = true   -- Highlight all search matches
vim.opt.ignorecase = true -- Case-sensitive search (see smartcase)
vim.opt.smartcase = true  -- Override ignorecase if search includes uppercase letters
vim.opt.cursorline = true -- Highlight on which line the cursor is on
vim.opt.winborder = "rounded"
vim.opt.signcolumn = "yes"

-- Tabs and Indentation
vim.opt.tabstop = 2      -- Number of spaces per tab
vim.opt.shiftwidth = 2   -- Number of spaces for each indentation level
vim.opt.expandtab = true -- Convert tabs to spaces

-- Completion
vim.opt.completeopt = { -- Completion options for better UX
    'menu',             -- Show completion menu
    'menuone',          -- Show menu even for a single match
    'noselect'          -- Don't auto-select any completion item
}

