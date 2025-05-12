return {
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "package.json", ".git" },
  init_options = {
    typescript = {
      tsdk = vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib/",
    },
  },
  -- before_init = function(_, config)
  --   if config.init_options and config.init_options.typescript and config.init_options.typescript.tsdk == "" then
  --     config.init_options.typescript.tsdk = util.get_typescript_server_path(config.root_dir)
  --   end
  -- end,
}
