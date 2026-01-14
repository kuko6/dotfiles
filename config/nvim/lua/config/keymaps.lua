vim.keymap.set({ 'n', 'x' }, 'cp', '"+y', { desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'x' }, 'cv', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set('n', ',', ':noh<cr>', { desc = 'Hide highlights' })
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = 'Open netrw' })
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })

vim.keymap.set({ 'n', 'x', 'i' }, '<S-Down>', '<C-d>', { desc = 'Page half down' })
vim.keymap.set({ 'n', 'x', 'i' }, '<S-Up>', '<C-u>', { desc = 'Page half up' })

-- fzf keybinds
local fzf = require('fzf-lua')
vim.keymap.set('n', '<leader>f', fzf.files, { desc = 'Open file picker' })
vim.keymap.set('n', 'g/', fzf.live_grep, { desc = 'Search with grep' })
vim.keymap.set('n', '<leader>/', fzf.live_grep, { desc = 'Search with grep' })
vim.keymap.set('n', '<leader>b', fzf.buffers, { desc = 'Open buffer picker' })
vim.keymap.set('n', '<leader>r', fzf.registers, { desc = 'Open registers' })
vim.keymap.set('n', '<leader>h', fzf.help_tags, { desc = 'Open help tags' })
vim.keymap.set('n', '<leader>s', fzf.treesitter, { desc = 'Open treesitter symbols' })
vim.keymap.set('n', '<leader>j', fzf.jumps, { desc = 'Open jumplist' })
vim.keymap.set('n', '<leader>d', fzf.diagnostics_workspace, { desc = 'Open workspace diagnostics picker' })
vim.keymap.set('n', '<leader>g', fzf.git_status, { desc = 'Open changed / diff picker' })
vim.keymap.set('n', '<leader>?', fzf.keymaps, { desc = 'Show keymaps' })

local map = function(mode, keys, func, desc)
    vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = desc })
end

-- copilot keybinds
vim.g.copilot_on = false
vim.keymap.set("n", "<leader>cp", function()
  require("copilot.suggestion").toggle_auto_trigger()
  vim.g.copilot_on = not vim.g.copilot_on

  if vim.g.copilot_on then
    vim.notify("Copilot Enabled", vim.log.levels.INFO, { title = "Copilot" })
  else
    vim.notify("Copilot Disabled", vim.log.levels.WARN, { title = "Copilot" })
  end
end, { desc = "Toggle Copilot Auto Trigger" })

-- lsp keybinds
map('n', 'gh', vim.diagnostic.open_float, 'Hover diagnostics')
map('n', '[d', vim.diagnostic.goto_prev, 'Go to prev diagnostic')
map('n', ']d', vim.diagnostic.goto_next, 'Go to next diagnostic')
map('n', '<leader>dd', vim.diagnostic.setloclist, 'Show diagnostics bar')

vim.keymap.set("n", "<leader>i", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end, { desc = "Toggle inlay hints" })

map('n', '<leader>k', vim.lsp.buf.hover, 'LSP: Hover under cursor')
map('n', 'gi', vim.lsp.buf.implementation, 'LSP: Go to implementation')
map('n', 'gd', vim.lsp.buf.definition, 'LSP: Go to definition')
map('n', 'gr', vim.lsp.buf.references, 'LSP: Go to references')
map('n', 'cd', vim.lsp.buf.rename, 'LSP: Rename')
map('n', 'g.', vim.lsp.buf.code_action, 'LSP: Code action')
map('n', '<leader>a', vim.lsp.buf.code_action, 'LSP: Code action')
map('n', '<leader>=', function()
    vim.lsp.buf.format({ async = true })
end, 'LSP: Format')

-- git keybinds
local gitsigns = require('gitsigns')
map('n', 'do', gitsigns.preview_hunk, 'Git: Preview hunk')
map('n', '<leader>hp', gitsigns.preview_hunk_inline, 'Git: Preview hunk inline')
map('n', '<leader>hs', gitsigns.stage_hunk, 'Git: Stage hunk')
map('n', '<leader>hr', gitsigns.reset_hunk, 'Git: Reset hunk')

map('n', ']c', function()
    if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
    else
        gitsigns.nav_hunk('next')
    end
end, 'Git: Navigate to next change')

map('n', '[c', function()
    if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
    else
        gitsigns.nav_hunk('prev')
    end
end, 'Git: Navigate to prev change')

map('n', '<leader>hQ', function() gitsigns.setqflist('all') end, 'Git: Show changes in project')
map('n', '<leader>hq', gitsigns.setqflist, 'Git: Show changes in file')
map('n', '<leader>tb', gitsigns.toggle_current_line_blame, 'Git: Toggle inline blame')
-- map('n', '<leader>gw', gitsigns.toggle_word_diff, 'Git: Toggle word diff')
