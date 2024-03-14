local config = require("plugins.configs.lspconfig")
local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")

local servers = { "pyright", "marksman", "efm" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

lspconfig.pyright.setup({
	filetypes = { "python" },
	cmd = { "pyright-langserver", "--stdio", "--pythonpath", "~/Code/.devel-env/bin/python" },
})

local efmls_config = require("custom.configs.efm")
lspconfig.efm.setup(vim.tbl_extend("force", efmls_config, {
	efmls_config,
}))
