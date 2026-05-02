return {
  {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",  -- nice diff views
    },
    config = function()
      require("neogit").setup({
        kind = "tab",
      })
      vim.keymap.set("n", "<leader>gg", function()
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "NeogitStatus" then
              vim.api.nvim_set_current_tabpage(tab)
              vim.api.nvim_set_current_win(win)
              require("neogit").refresh()
              return
            end
          end
        end
        vim.cmd("Neogit")
      end, { noremap = true })
    end,
  }
}
