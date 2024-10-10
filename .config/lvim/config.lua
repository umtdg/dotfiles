lvim.plugins = {
  { "tpope/vim-surround" },
}

lvim.colorscheme = "lunar"

lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c", "cpp",
  "python"
}

lvim.lsp.installer.setup.automatic_servers_installation = true
lvim.lsp.installer.setup.ensure_installed = {
  "bashls",
  "clangd",
  "pyright",
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "ruff",
    filetypes = { "python" },
  },
  {
    name = "clang_format",
    filetypes = { "c", "cpp" },
  },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    name = "ruff",
    filetypes = { "python" },
  },
  {
    name = "checkmake",
    filetypes = { "make" },
  },
  {
    name = "shellcheck",
    filetypes = { "sh", "bash" },
  },
}

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.autoindent = true
vim.opt.expandtab = true
