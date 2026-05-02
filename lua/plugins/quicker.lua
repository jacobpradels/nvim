return {
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    opts = {},
    config = function(_, opts)
      require("quicker").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function()
          vim.keymap.set("n", "<CR>", function()
            vim.cmd("cc " .. vim.fn.line("."))
          end, { buffer = true, nowait = true })
        end,
      })
    end,
  }
}
