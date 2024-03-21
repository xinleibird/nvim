vim.api.nvim_create_user_command("ToggleSemi", function(o)
  require("togglesemi").toggle(o.args)
end, {
  nargs = 1,
  desc = "Toggle semicolon at end of line",
  complete = function()
    return {
      ",",
      ";",
    }
  end,
})
