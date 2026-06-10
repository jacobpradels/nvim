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
vim.opt.redrawtime = 10000
vim.g.mapleader = " "

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true    -- language-aware auto indent
vim.opt.breakindent = true    -- wrapped lines maintain indent

vim.opt.wrap = false

vim.opt.number = true
vim.opt.clipboard = "unnamedplus"

-- cmd+/ to toggle comments (normal and visual)
vim.keymap.set("n", "<D-/>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<D-/>", "gc", { remap = true, desc = "Toggle comment" })

vim.keymap.set("n", "<leader>tc", "<cmd>tabc<cr>", { desc = "Close tab" })
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
    jsx = "typescriptreact",
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

vim.api.nvim_create_user_command("Pyi", function(opts)
  local arg = opts.args
  local python_path

  if vim.fn.isdirectory(arg) == 1 then
    local result = vim.fn.system("cd " .. vim.fn.shellescape(arg) .. " && poetry env info --path 2>&1")
    result = vim.trim(result)
    if vim.v.shell_error ~= 0 then
      vim.notify("poetry env info failed: " .. result, vim.log.levels.ERROR)
      return
    end
    python_path = result .. "/bin/python"
  else
    python_path = arg
  end

  -- Find pyrefly.toml by walking up from cwd
  local config_path = nil
  local dir = vim.fn.getcwd()
  while true do
    local candidate = dir .. "/pyrefly.toml"
    if vim.fn.filereadable(candidate) == 1 then
      config_path = candidate
      break
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then break end
    dir = parent
  end

  if not config_path then
    vim.notify("No pyrefly.toml found in " .. vim.fn.getcwd() .. " or any parent", vim.log.levels.ERROR)
    return
  end

  -- Read, update or insert python_interpreter, write back
  local lines = vim.fn.readfile(config_path)
  local found = false
  for i, line in ipairs(lines) do
    if line:match("^python_interpreter%s*=") then
      lines[i] = 'python_interpreter = "' .. python_path .. '"'
      found = true
      break
    end
  end
  if not found then
    table.insert(lines, 'python_interpreter = "' .. python_path .. '"')
  end
  vim.fn.writefile(lines, config_path)

  for _, client in ipairs(vim.lsp.get_clients({ name = "pyrefly" })) do
    vim.lsp.stop_client(client.id, true)
  end
  vim.schedule(function()
    vim.cmd("doautocmd FileType " .. vim.bo.filetype)
  end)

  vim.notify("Python interpreter: " .. python_path .. "\nWrote to: " .. config_path)
end, {
  nargs = 1,
  complete = "dir",
  desc = "Set Python interpreter (directory → poetry env, absolute path → used directly)",
})
