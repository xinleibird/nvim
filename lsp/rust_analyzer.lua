return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  single_file_support = true,
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = true,

      inlayHints = {
        bindingModeHints = {
          enable = false,
        },
        chainingHints = {
          enable = true,
        },
        closingBraceHints = {
          enable = true,
          minLines = 25,
        },
        closureReturnTypeHints = {
          enable = "never",
        },
        lifetimeElisionHints = {
          enable = "never",
          useParameterNames = false,
        },
        maxLength = 25,
        parameterHints = {
          enable = true,
        },
        reborrowHints = {
          enable = "never",
        },
        renderColons = true,
        typeHints = {
          enable = true,
          hideClosureInitialization = false,
          hideNamedConstructor = false,
        },
      },
    },
  },
  before_init = function(init_params, config)
    -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
    if config.settings and config.settings["rust-analyzer"] then
      init_params.initializationOptions = config.settings["rust-analyzer"]
    end
  end,
}
