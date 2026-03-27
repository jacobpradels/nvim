return {
  "okuuva/auto-save.nvim",
  opts = {
    enabled = true,
    trigger_events = {
      immediate_save = { "FocusLost" },
      defer_save = { "InsertLeave", "TextChanged" },
    },
    debounce_delay = 2000, -- ms delay for deferred saves
    save_on_focus_lost = true,
  },
}
