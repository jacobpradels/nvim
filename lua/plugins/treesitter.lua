return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "tsx", "jsx", "markdown", "markdown_inline" },
        highlight = { enable = true },
        indent = { enable = true, disable = { "python" } },
      })
      vim.keymap.set("n", "<leader>t", function()
        vim.cmd("Neotree toggle")
      end)
    end,
  }
}
