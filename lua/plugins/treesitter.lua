return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "tsx", "jsx", "markdown", "markdown_inline" },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = false },
      })
    end,
  }
}
