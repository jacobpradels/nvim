return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ts_ls", "tailwindcss", "pyrefly", "rust_analyzer" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("lua_ls", {})
      vim.lsp.config("ts_ls", {
        root_markers = { "tsconfig.json", "package.json" },
        single_file_support = false,
      })
      vim.lsp.config("tailwindcss", {})
      -- vim.lsp.config("pyright", {})
      vim.lsp.config("pyrefly", {
        settings = {
          pyrefly = {
            pythonInterpreter = "/Users/jacobpradels/Library/Caches/pypoetry/virtualenvs/orgs-2elLltSQ-py3.14/bin/python",
          },
        },
      })
      vim.lsp.config("rust_analyzer", {})

      vim.lsp.enable("lua_ls")
      -- vim.lsp.enable("pyright")
      vim.lsp.enable("pyrefly")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("tailwindcss")
      vim.lsp.enable("rust_analyzer")

      vim.diagnostic.config({
        virtual_text = false,  -- disables the inline text at end of line
        float = {
          focusable = false,
          border = "rounded",
        },
      })

      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)

      vim.keymap.set("n", "gd", vim.lsp.buf.definition)
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = "rounded",
        }
      )

      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float()
          vim.lsp.buf.hover()
        end,
      })

    end,
  },
}
