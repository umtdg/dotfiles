lvim.plugins = {
  { "olimorris/onedarkpro.nvim" },
  { "tpope/vim-surround" },
}

lvim.colorscheme = "onedark"

lvim.lsp.automatic_servers_installation = false

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "black",
    filetypes = { "python" },
    args = {
      "--line-length", "80",
    },
  },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    name = "flake8",
    filetypes = { "python" },
  },
}

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.autoindent = true
vim.opt.expandtab = true

vim.opt.clipboard.append("unnamedplus")

