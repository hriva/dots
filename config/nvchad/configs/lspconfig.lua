local config = require("plugins.configs.lspconfig")
local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")

lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
  cmd = { "pyright-langserver", "--stdio", "--pythonpath", "~/Code/.devel-env/bin/python"}
})
-- "venv": "a-name-for-your-venv",  
-- "venvPath": "/opt/homebrew/Caskroom/miniconda/base/envs/"
