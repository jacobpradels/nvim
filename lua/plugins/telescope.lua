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
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local function open_in_editor_tab(filepath)
        local editor_tab = nil
        for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
          local is_neogit = false
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
            if vim.bo[vim.api.nvim_win_get_buf(win)].filetype:match("^Neogit") then
              is_neogit = true
              break
            end
          end
          if not is_neogit then
            editor_tab = tabpage
            break
          end
        end
        if editor_tab then
          vim.api.nvim_set_current_tabpage(editor_tab)
        else
          vim.cmd("tabnew")
        end
        vim.cmd("edit " .. vim.fn.fnameescape(filepath))
      end

      local smart_open = function(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local filepath = entry.path or entry.filename
        if filepath then
          open_in_editor_tab(filepath)
          if entry.lnum then
            vim.schedule(function()
              vim.api.nvim_win_set_cursor(0, { entry.lnum, (entry.col or 1) - 1 })
              vim.cmd("normal! zz")
            end)
          end
        end
      end

    require("telescope").setup({
        defaults = {
          mappings = {
            i = { ["<CR>"] = smart_open },
            n = { ["<CR>"] = smart_open },
          },
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

      local function live_grep_in_dir(dir)
        require("telescope.builtin").live_grep({
          additional_args = { "--hidden" },
          search_dirs = { dir },
          prompt_title = "Grep in " .. vim.fn.fnamemodify(dir, ":~:."),
          attach_mappings = function(_, map)
            map("i", "<C-f>", function(prompt_bufnr)
              local entry = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              local next_dir = vim.fn.fnamemodify(entry.path or entry.filename, ":h")
              live_grep_in_dir(next_dir)
            end)
            return true
          end,
        })
      end

      vim.keymap.set("n", "<leader>p", require("telescope.builtin").find_files)
      vim.keymap.set("n", "<leader>fg", function()
        live_grep_in_dir(vim.fn.getcwd())
      end)
      vim.keymap.set("n", "<leader>fd", function()
        local dir = vim.fn.input("Search dir: ", vim.fn.getcwd() .. "/", "dir")
        if dir == "" then return end
        live_grep_in_dir(dir)
      end, { desc = "Live grep in directory" })
      vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)

      -- navigate quickfix list (populate with <C-q> from telescope)
      vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
      vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Prev quickfix" })
    end,
  }
}
