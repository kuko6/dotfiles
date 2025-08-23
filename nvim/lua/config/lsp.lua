local keymaps_config = require('config.keymaps')

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})

-- Common Python root markers
local python_root_markers = {
  'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile',
  'pyrightconfig.json', 'ruff.toml', '.ruff.toml', '.git'
}

-- Disable python provider (idk, what it does but its much faster now)
vim.g.loaded_python3_provider = 0

vim.lsp.config.pyright = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = python_root_markers,
    single_file_support = true,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
                typeCheckingMode = 'off'
            },
        },
    },
}

vim.lsp.config.ruff = {
    cmd = { 'ruff', 'server', '--preview' },
    filetypes = { 'python' },
    root_markers = python_root_markers,
    single_file_support = true,
    settings = {},
}

vim.lsp.config.harper = {
  cmd = { 'harper-ls', '--stdio' },
  filetypes = { 'typst', 'markdown' },
  root_markers = { '.git' },
  single_file_support = true,
  settings = {
    dialect = "British",
    linters = {
      SentenceCapitalization = false,
    }
  }
}

vim.lsp.config.tinymist = {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
    root_markers = { '.git' },
    single_file_support = true,
    settings = {
        formatterMode = "typstyle",
        -- exportPdf = "onType",
    },
}

vim.lsp.config.sourcekit = {
    cmd = { 'sourcekit-lsp' },
    filetypes = { 'swift', 'c', 'cpp', 'objective-c', 'objective-cpp' },
    root_markers = { 'Package.swift', '.git' },
    single_file_support = true,
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
}

-- Enable LSPs
vim.lsp.enable('pyright')
vim.lsp.enable('ruff')
vim.lsp.enable('tinymist')
vim.lsp.enable('sourcekit')
vim.lsp.enable('harper')

-- Attach keymaps to all LSP clients
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            keymaps_config.on_attach(client, args.buf)
        end
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
                return client:supports_method(method, bufnr)
            else
                return client.supports_method(method, { bufnr = bufnr })
            end
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })

            -- When cursor stops moving: Highlights all instances of the symbol under the cursor
            -- When cursor moves: Clears the highlighting
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})
