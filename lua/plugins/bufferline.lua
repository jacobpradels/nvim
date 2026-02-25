return {
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({})
      vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>")
      vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>")
      -- vim.keymap.set("n", "<leader>x", ":bdelete<CR>")  -- close buffer
      vim.keymap.set("n", "<leader>x", function()
        local buf = vim.api.nvim_get_current_buf()
        require("bufferline").cycle(1)
        vim.cmd("bdelete " .. buf)
      end, { desc = "Close buffer" })
    end,
  }
}
