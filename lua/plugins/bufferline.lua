return {
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "famiu/bufdelete.nvim",
    },
    config = function()
      require("bufferline").setup({
        options = {
          close_command = function(bufnum)
            require("bufdelete").bufdelete(bufnum, true)
          end,
          right_mouse_command = function(bufnum)
            require("bufdelete").bufdelete(bufnum, true)
          end,
        },
      })
      vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>")
      vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>")
      vim.keymap.set("n", "<leader>x", "<cmd>Bdelete<cr>", { desc = "Close buffer" })
    end,
  },
}
