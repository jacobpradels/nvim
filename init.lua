-- ~/.config/nvim/init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
vim.opt.updatetime = 500
vim.g.mapleader = " "
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<leader>sv", "<cmd>vsp<cr>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>sh", "<cmd>sp<cr>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close split" })

-- easier navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

vim.filetype.add({
  extension = {
    tsx = "typescriptreact",
    jsx = "javascriptreact",
  },
})

vim.opt.autoread = true

-- run command :MinimapToggle
vim.keymap.set("n", "<F4>", ":MinimapToggle<CR>", { desc = "Toggle Minimap" })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

require("lazy").setup("plugins")
