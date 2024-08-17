local config = require("nvchad.configs.lspconfig")
local on_attach = config.on_attach
local capabilities = config.capabilities
-- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
local on_init = config.on_init

require("mason").setup()
local lspconfig = require("lspconfig")

local servers = {
	"marksman",
	-- "efm",
	"r_language_server",
	"basedpyright",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {
			allow_incremental_sync = true,
		},
	})
end

-- local efmls_config = require("configs.efm")
-- lspconfig.efm.setup(vim.tbl_extend("force", efmls_config, {
-- 	efmls_config,
-- }))

lspconfig.r_language_server.setup({
	settings = {
		diagnostics = true,
		lint_cache = true,
	},
	flags = { debounce_text_changes = 200 },
})

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
				diagnosticSeverityOverrides = { "error", "warning" },
				-- stubPath = os.getenv("HOME") .. "/Code/.python-stubs/typings",
			},
		},
	},
})
