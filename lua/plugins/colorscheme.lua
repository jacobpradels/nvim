return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local function get_system_style()
        local result = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null")
        return vim.trim(result) == "Dark" and "dark" or "light"
      end

      local function apply_theme()
        local style = get_system_style()
        require("vscode").setup({ style = style })
        require("vscode").load()
      end

      apply_theme()

      vim.api.nvim_create_autocmd("FocusGained", {
        callback = apply_theme,
      })
    end,
  }
}
