return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
        },
      })
      vim.keymap.set("n", "<leader>t", function()
        vim.cmd("Neotree toggle")
      end)
    end,
  }
}
