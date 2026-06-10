return {
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("claude-code").setup({
        window = {
          position = "float",
          enter_insert = true,
          hide_numbers = true,
          hide_signcolumn = true,
          float = {
            width = "80%",
            height = "80%",
            row = "center",
            col = "center",
            relative = "editor",
            border = "rounded",
          },
        },
      })

      vim.keymap.set({ "n", "t" }, "<leader>cc", function()
        require("claude-code").toggle()
      end, { desc = "Toggle Claude Code" })

      -- In the claude terminal, gf jumps to file:line under cursor.
      -- Press <Esc> to enter normal mode, position cursor on a path, then gf.
      local function jump_to_file_ref()
        local cword = vim.fn.expand("<cWORD>")
        -- strip surrounding punctuation (backticks, quotes, parens, trailing dots/commas)
        cword = cword:gsub("^[`\"'(]", ""):gsub("[`\"'.,;):]$", "")

        local filepath, lnum = cword:match("^([^:]+):(%d+)")
        if not filepath then
          filepath = cword
        end

        if vim.fn.filereadable(filepath) == 0 then
          vim.notify("Not a readable file: " .. filepath, vim.log.levels.WARN)
          return
        end

        require("claude-code").toggle()
        vim.cmd("edit " .. vim.fn.fnameescape(filepath))
        if lnum then
          vim.api.nvim_win_set_cursor(0, { tonumber(lnum), 0 })
          vim.cmd("normal! zz")
        end
      end

      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*claude*",
        callback = function(ev)
          vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {
            buffer = ev.buf,
            desc = "Exit terminal mode",
          })
          vim.keymap.set("n", "gf", jump_to_file_ref, {
            buffer = ev.buf,
            desc = "Jump to file reference under cursor",
          })
        end,
      })
    end,
  },
}
