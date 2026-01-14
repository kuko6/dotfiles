vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = false,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
})

-- let omni-completion (<C-x><C-o>) use lsp
vim.o.omnifunc = 'v:lua.vim.lsp.omnifunc'

local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = true })

-- common Python root markers
local python_root_markers = {
    'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile',
    'pyrightconfig.json', 'ruff.toml', '.ruff.toml', '.git'
}

-- disable python provider (idk, what it does but its much faster now)
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

vim.lsp.config.ty = {
    cmd = { 'ty', 'server' },
    filetypes = { 'python' },
    root_markers = python_root_markers,
    single_file_support = true,
    -- settings = { ty = { } }
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
    root_markers = { 'harper.toml', 'harper.yaml', 'harper.yml', 'harper.json', '.git' },
    single_file_support = true,
    settings = {
        ['harper-ls'] = {
            dialect = 'British',
            linters = {
                SentenceCapitalization = false,
            },
        },
    },
}

vim.lsp.config.tinymist = {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
    root_markers = { 'typst.toml', 'typst.yml', 'typst.yaml', 'main.typ', 'lib.typ', '.git' },
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

vim.lsp.config.rust_analyzer = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
    single_file_support = true,
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
            },
            checkOnSave = {
                command = 'clippy',
            },
        },
    },
}

vim.lsp.config.deno = {
    cmd = { 'deno', 'lsp' },
    filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    root_markers = { 'deno.json', 'deno.jsonc', 'deno.lock' },
    single_file_support = true,
    settings = {}
}

vim.lsp.config.tsserver = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' },
    single_file_support = false,
    settings = {},
}

vim.lsp.config.tailwindcss = {
    cmd = { 'tailwindcss-language-server', '--stdio' },
    filetypes = {
        'html',
        'css',
        'postcss',
        'sass',
        'scss',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'svelte'
    },
    root_markers = { 'tailwind.config.js', 'postcss.config.js', 'package.json' },
    single_file_support = true,
    settings = {},
}

vim.lsp.config.svelte = {
    cmd = { 'svelteserver', '--stdio' },
    filetypes = { 'svelte' },
    root_markers = { 'svelte.config.js', 'package.json' },
    single_file_support = true,
    settings = {},
}

-- Enable LSPs
-- vim.lsp.enable('pyright')
vim.lsp.enable('ty')
vim.lsp.enable('ruff')
vim.lsp.enable('tinymist')
vim.lsp.enable('sourcekit')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('harper')
vim.lsp.enable('deno')
vim.lsp.enable('tsserver')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('svelte')

-- highlight symbol under cursor
vim.api.nvim_create_autocmd("LspAttach", {
    group = highlight_augroup,
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client or not client:supports_method('textDocument/documentHighlight', event.buf) then
            return
        end

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
    end,
})

-- inlay hints
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client.supports_method("textDocument/inlayHint") then
      return
    end

    vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
  end,
})
