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
        ensure_installed = { "lua_ls", "pyrefly", "ts_ls", "tailwindcss", "rust_analyzer", "gopls", "zls" },
        automatic_enable = false,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("ts_ls", {
        root_markers = { "tsconfig.json", "package.json" },
        single_file_support = false,
      })

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("pyrefly")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("tailwindcss")
      vim.lsp.enable("rust_analyzer")
      vim.lsp.enable("gopls")
      vim.lsp.enable("zls")

      vim.diagnostic.config({
        virtual_text = false,  -- disables the inline text at end of line
        float = {
          focusable = false,
          border = "rounded",
        },
      })

      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)

      vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition({
          on_list = function(options)
            local seen = {}
            local unique = {}
            for _, item in ipairs(options.items) do
              local key = item.filename .. ":" .. item.lnum .. ":" .. item.col
              if not seen[key] then
                seen[key] = true
                table.insert(unique, item)
              end
            end
            if #unique == 1 then
              vim.cmd("edit " .. vim.fn.fnameescape(unique[1].filename))
              vim.api.nvim_win_set_cursor(0, { unique[1].lnum, unique[1].col - 1 })
            else
              options.items = unique
              vim.fn.setqflist({}, " ", options)
              vim.cmd("copen")
            end
          end,
        })
      end)
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float()
        end,
      })

    end,
  },
}
