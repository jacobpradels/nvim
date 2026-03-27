local special_files = {
  tsx = { "index", "page" },
  ts = { "index", "types", "consts" },
  js = { "index" },
  py = { "__init__", "handler", "server" },
}

return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
    require("telescope").setup({
        defaults = {
          path_display = function(_, path)
            local tail = require("telescope.utils").path_tail(path)
            local name, ext = tail:match("^(.+)%.(.+)$")

            if name and ext and special_files[ext] then
              for _, special in ipairs(special_files[ext]) do
                if name == special then
                  local parent = vim.fn.fnamemodify(path, ":h:t")
                  return parent .. " - " .. tail
                end
              end
            end

            local relative = vim.fn.fnamemodify(path, ":~:.")
            local dir = vim.fn.fnamemodify(path, ":~:.:h")
            local display = tail .. " - " .. dir

            return display, {
              { { 0, #tail }, "TelescopeResultsField" },           -- bright filename
              { { #tail, #display }, "TelescopeResultsComment" },  -- dimmed " - path"
            }
          end,
        }
      })

      vim.keymap.set("n", "<leader>p", require("telescope.builtin").find_files)
      vim.keymap.set("n", "<leader>fg", function()
        require("telescope.builtin").live_grep({
          additional_args = { "--hidden" },
        })
      end)
      vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
    end,
  }
}
