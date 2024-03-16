local config = require("nvchad.configs.lspconfig")
local on_attach = config.on_attach
local capabilities = config.capabilities
local on_init = config.on_init

require("mason").setup()
local lspconfig = require("lspconfig")

local servers = {
	"pyright",
	"marksman",
	"efm",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

lspconfig.pyright.setup({
	filetypes = { "python" },
	cmd = { "pyright-langserver", "--stdio" },
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
			},
		},
	},
})

local efmls_config = require("configs.efm")
lspconfig.efm.setup(vim.tbl_extend("force", efmls_config, {
	efmls_config,
}))