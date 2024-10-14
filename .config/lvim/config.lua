lvim.plugins = {
  { "tpope/vim-surround" },
  { "olimorris/onedarkpro.nvim" },
}

lvim.colorscheme = "onedark"

lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { "python" }
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c", "cpp",
  "python",
  "rust",
}

lvim.lsp.installer.setup.automatic_servers_installation = true
vim.list_extend(lvim.lsp.installer.setup.ensure_installed, {
  "bashls",
  "clangd",
  "pyright",
})

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "black",
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

lvim.autocommands = {
  {
    "BufWinEnter", {
      pattern = { "*.rs" },
      command = "setlocal shiftwidth=2 tabstop=2 softtabstop=2"
    }
  }
}
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
