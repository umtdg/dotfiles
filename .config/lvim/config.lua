lvim.plugins = {
  { "tpope/vim-surround" },
}

lvim.colorscheme = "lunar"

lvim.lsp.installer.setup.automatic_installation = true
lvim.lsp.installer.setup.ensure_installed = { "clangd", "pyright" }

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "ruff",
    filetypes = { "python" },
  },
  {
    name = "clang_format",
    filetypes = { "c", "cpp" },
  }
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    name = "ruff",
    filetypes = { "python" },
  },
}

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.autoindent = true
vim.opt.expandtab = true

