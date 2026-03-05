local dap = require("dap")

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    -- 💀 Make sure to update this path to point to your installation
    args = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
  },
}

dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch with [pwa-node]",
    program = "${file}",
    console = "integratedTerminal",
    cwd = "${workspaceFolder}",
  },
}

dap.configurations.typescript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    runtimeExecutable = "deno",
    runtimeArgs = {
      "run",
      "--check",
      "--inspect-wait",
      "--allow-all",
    },
    console = "integratedTerminal",
    program = "${file}",
    cwd = "${workspaceFolder}",
    attachSimplePort = 9229,
  },
}
