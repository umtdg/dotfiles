lvim.plugins = {
  { "olimorris/onedarkpro.nvim" },
  { "tpope/vim-surround" },
}

lvim.colorscheme = "onedark"

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "black",
    filetypes = { "python" },
  },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    name = "mypy",
  }
}

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.autoindent = true
vim.opt.expandtab = true

vim.opt.clipboard.append("unnamedplus")

