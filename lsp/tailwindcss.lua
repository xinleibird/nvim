local settings = {}
for _, lang in ipairs({
  "html",
  "css",
  "scss",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
}) do
  settings[lang] = {}
end

return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  root_markers = { "tailwind.config.js", "package.json", ".git" },
  single_file_support = true,

  settings = settings,
}
