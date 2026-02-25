return {
  'wfxr/minimap.vim',
  build = "cargo install code-minimap",
  cmd = { 'Minimap', 'MinimapClose', 'MinimapToggle' },
  config = function()
    vim.g.minimap_width = 10
    vim.g.minimap_auto_start = 1
    vim.g.minimap_auto_start_win_enter = 1
    vim.g.minimap_git_colors = 1  -- enable git highlights
    vim.keymap.set('n', '<leader>mm', ':MinimapToggle<CR>')
  end,
}
