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
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slot = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = '/usr/bin/firefox'
    end,
  },
  { url = "https://gitlab.com/schrieveslaach/sonarlint.nvim.git" },
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      local actions_preview = require("actions-preview")
      actions_preview.setup({
        -- vim.diff() options
        diff = {
          ctxlen = 3,
        },
        -- priority list of external command to highlight diff
        highlight_command = {
          require("actions-preview.highlight").diff_so_fancy()
        },

        -- backend priority list
        backend = { "telescope" },

        telescope = {
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          }
        }
      })
      vim.keymap.set({ "v", "n" }, "<leader>lc", actions_preview.code_actions)
    end,
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

local lspconfig = require('lspconfig')

require("lvim.lsp.null-ls.formatters").setup({
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
})

require("lvim.lsp.null-ls.linters").setup({
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
})

vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local lsps = lspconfig.util.available_servers()
for _, ls in ipairs(lsps) do
  lspconfig[ls].setup({
    capabilities = capabilities,
  })
end
local nvim_ufo = require("ufo")
nvim_ufo.setup({
  provider_selector = function(bufnr, filetype, buftype)
    return { 'lsp', 'indent' }
  end
})

require('sonarlint').setup({
  server = {
    cmd = {
      'sonarlint-language-server',
      '-stdio',
      '-analyzers',
      vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
      vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
    }
  },
  filetypes = {
    "cpp",
    "python"
  }
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

-- Markdown
vim.cmd [[
  let g:mkdp_auto_start = 0
  let g:mkdp_auto_close = 1
  let g:mkdp_refresh_slow = 0
  let g:mkdp_command_for_global = 0
  let g:mkdp_open_to_the_world = 0
  let g:mkdp_browser = '/usr/bin/firefox'
]]

