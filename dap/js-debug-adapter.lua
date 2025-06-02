local dap = require("dap")

for _, adapter in ipairs({
  "pwa-extensionHost",
  "node-terminal",
  "pwa-node",
  "pwa-chrome",
  "pwa-msedge",
}) do
  dap.adapters[adapter] = {
    executable = {
      command = "js-debug-adapter",
      args = { "${port}" },
    },
    host = "localhost",
    port = "${port}",
    type = "server",
  }
end

-- for _, lang in ipairs({
--   "typescript",
--   "javascript",
--   "typescriptreact",
--   "javascriptreact",
-- }) do
--   dap.configurations[lang] = {
--     {
--       name = "Launch Chrome",
--       reAttach = true,
--       request = "launch",
--       type = "pwa-chrome",
--       url = "http://localhost:8080",
--       webRoot = "${workspaceFolder}",
--     },
--   }
-- end
