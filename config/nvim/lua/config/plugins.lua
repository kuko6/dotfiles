vim.pack.add({
  { src = "https://github.com/rose-pine/neovim",                            name = "rose-pine" },
  -- { src = "https://github.com/junegunn/seoul256.vim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter",             branch = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
  -- { src = "https://github.com/saghen/blink.cmp",                            version = vim.version.range("1") },
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/FabijanZulj/blame.nvim",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/norcalli/nvim-colorizer.lua",
  "https://github.com/nvim-mini/mini.ai",
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/nvim-mini/mini.move",
  "https://github.com/nvim-mini/mini.tabline",
  "https://github.com/nvim-mini/mini.statusline",
})

-- Pack utilities
local function remove_inactive_plugins()
  local inactive = vim.iter(vim.pack.get())
      :filter(function(x) return not x.active end)
      :map(function(x) return x.spec.name end)
      :totable()

  if #inactive == 0 then
    vim.notify("No inactive plugins found")
    return
  end

  vim.notify(table.concat(inactive, ", "))

  local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.pack.del(inactive)
    vim.notify("Removed " .. #inactive .. " plugin(s): " .. table.concat(inactive, ", "))
  end
end

local function list_plugins()
  local chunks = {}
  for _, x in ipairs(vim.pack.get()) do
    local line = string.format("%-40s %-10s [%s]\n", x.spec.name, x.rev:sub(1, 7), x.active and "active" or "inactive")
    local hl = x.active and "Normal" or "Comment"
    table.insert(chunks, { line, hl })
  end
  vim.api.nvim_echo(chunks, false, {})
end

vim.api.nvim_create_user_command("PackClean", remove_inactive_plugins, {})
vim.api.nvim_create_user_command("PackList", list_plugins, {})
vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update()
end, {})

-- configs for plugins

-- lazy loading, maybe?
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    require("mini.pairs").setup()
  end,
})

-- theme
-- vim.opt.background = 'dark'
-- vim.g.seoul256_background = 236
-- vim.g.seoul256_srgb = 1 -- fixes colors for some terminals
-- vim.cmd.colorscheme('seoul256')

require("rose-pine").setup({
  variant = "moon",      -- auto, main, moon, or dawn
  dark_variant = "moon", -- main, moon, or dawn
  styles = {
    bold = false,
    italic = false,
    transparency = false,
  },
  highlight_groups = {
    Visual = { bg = "highlight_high", inherit = false },
  },
})
vim.cmd.colorscheme("rose-pine")

require("fzf-lua").setup({
  "max-perf",
  multiprocess = true
})

require("colorizer").setup({
  "*",
  css = { rgb_fn = true },
})

require("which-key").setup({
  delay = 800,
  icons = { mappings = false }
})

require("ibl").setup({
  scope = { enabled = false },
  indent = { char = "│", tab_char = "│" },
})

require("blame").setup()

-- treesitter
require('nvim-treesitter').install { "svelte", "markdown", "lua", "typst", "typescript", "javascript", "c", "python" }
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "svelte", "markdown", "lua", "typst", "typescript", "javascript", "c", "python" },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end
})
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- indentation

require("nvim-treesitter-textobjects").setup {
  select = {
    lookahead = true,
    selection_modes = {
      ["@parameter.outer"] = "v",
      ["@function.outer"] = "V"
    }
  },
  move = { set_jumps = true }
}

-- completions
-- require("blink.cmp").setup({
--   keymap = {
--     preset = "enter",
--     ["<Up>"] = { "select_prev", "fallback" },
--     ["<Down>"] = { "select_next", "fallback" },
--   },
--   signature = { enabled = true },
--   completion = {
--     documentation = { auto_show = true, auto_show_delay_ms = 100 },
--     ghost_text = { enabled = false },
--     accept = {
--       auto_brackets = { enabled = true },
--     },
--     menu = {
--       draw = { treesitter = { "lsp" } },
--     },
--   },
--   fuzzy = { implementation = "prefer_rust_with_warning" },
-- })

-- mini
require("mini.move").setup()
require("mini.surround").setup()
require("mini.ai").setup { n_lines = 500 }
require("mini.tabline").setup()

-- NOTE: try to find a way how to use the native diagnostics in there
-- because those do look nice
local statusline = require("mini.statusline")
statusline.setup({
  use_icons = true,
  content = {
    active = function()
      local mode, mode_hl = statusline.section_mode({ trunc_width = 70 })
      local git = statusline.section_git({ trunc_width = 40 })
      -- local diff = statusline.section_diff({ trunc_width = 80 })
      local diagnostics = statusline.section_diagnostics({ trunc_width = 70 })
      local filename = statusline.section_filename({ trunc_width = 100 })
      local fileinfo = statusline.section_fileinfo({ trunc_width = 140 })
      local location = statusline.section_location()

      return statusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        { hl = "MiniStatuslineDevinfo",  strings = { git } },
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- separator
        { hl = "MiniStatuslineDevinfo",  strings = { diagnostics } },
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo, location } },
      })
    end,
  },
})

statusline.section_location = function()
  return "%2l:%-2v"
end
