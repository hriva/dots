local config = require("nvchad.configs.lspconfig")
local on_attach = config.on_attach
local capabilities = config.capabilities
local on_init = config.on_init

require("mason").setup()
local lspconfig = require("lspconfig")

local servers = {
	"marksman",
	-- "efm",
	"basedpyright",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- local efmls_config = require("configs.efm")
-- lspconfig.efm.setup(vim.tbl_extend("force", efmls_config, {
-- 	efmls_config,
-- }))

lspconfig.basedpyright.setup({
	filetypes = { "python" },
	settings = {
		basedpyright = {
			analysis = {
				logLevel = "Information",
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				typeCheckingMode = "off",
				diagnosticMode = "openFilesOnly",
				indexing = true,
			},
		},
	},
})
