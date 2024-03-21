local M = {
  "lukas-reineke/virt-column.nvim",
  event = "VimEnter",
  config = function()
    require("virt-column").setup({
      char = "",
      highlight = "VirtColumn",
    })

    vim.api.nvim_create_autocmd({ "BufReadPre" }, {
      pattern = {
        "*.{css,scss,sass}",
        "*.{Dockerfile,dockerfile}",
        "*.{go}",
        "*.{htm,html,xml}",
        "*.{js,jsx,ts,tsx,ejs,vue}",
        "*.{json,yaml,yml,toml,{.,}prettierrc,{.,}eslintrc,{.,}stylelintrc}",
        "*.{lua}",
        "*.{md,markdown}",
        "*.{php}",
        "*.{rs}",
        "*.{sh,bash,zsh}",
      },
      group = vim.api.nvim_create_augroup("user_virt_column_group", { clear = true }),
      callback = function()
        require("virt-column").setup_buffer(0, {
          virtcolumn = "80,110",
        })
      end,
    })
  end,
}

return M
