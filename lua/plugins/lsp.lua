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
        ensure_installed = { "lua_ls", "pyright", "ts_ls", "tailwindcss" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("lua_ls", {})
      vim.lsp.config("pyright", {})
      vim.lsp.config("ts_ls", {
        root_markers = { "tsconfig.json", "package.json" },
        single_file_support = false,
      })
      vim.lsp.config("tailwindcss", {})
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("pyright")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("tailwindcss")

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
