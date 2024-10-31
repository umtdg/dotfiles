lvim.plugins = {
  { "tpope/vim-surround" },
  { "olimorris/onedarkpro.nvim" },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VeryLazy",
    config = function(_, opts)
      require("ufo").setup(opts)
    end
  },
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
    command = "black",
    filetypes = { "python" },
    args = {
      "--preview",
      "--stdin-filename", "$FILENAME",
      "--quiet", "-",
    },
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


vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
local lsps = require('lspconfig').util.available_servers()
for _, ls in ipairs(lsps) do
  require('lspconfig')[ls].setup({
    capabilities = capabilities,
  })
end
local nvim_ufo = require("ufo")
nvim_ufo.setup({
  provider_selector = function(bufnr, filetype, buftype)
    return { 'lsp', 'indent' }
  end
})

vim.keymap.set("n", "zR", nvim_ufo.openAllFolds)
vim.keymap.set("n", "zM", nvim_ufo.closeAllFolds)
vim.keymap.set("n", "zr", nvim_ufo.openFoldsExceptKinds)
vim.keymap.set("n", "zm", nvim_ufo.closeFoldsWith)

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.autoindent = true
vim.opt.expandtab = true

lvim.autocommands = {
  {
    "BufWinEnter",
    {
      pattern = { "*.rs" },
      command = "setlocal shiftwidth=4 tabstop=4 softtabstop=4"
    }
  }
}
