return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({ style = "dark" })
      require("vscode").load()
    end,
  }
}
