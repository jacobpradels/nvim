return {
  {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",  -- nice diff views
    },
    config = function()
      require("neogit").setup({})
      vim.keymap.set("n", "<leader>gg", ":Neogit<CR>")
    end,
  }
}
