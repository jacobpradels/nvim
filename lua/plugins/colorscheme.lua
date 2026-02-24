return {
  {
    "folke/tokyonight.nvim",  -- swap for whatever theme you want
    lazy = false,
    priority = 1000,          -- load before everything else
    config = function()
      vim.cmd("colorscheme tokyonight")
    end,
  }
}
