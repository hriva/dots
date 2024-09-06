local nvlsp = require("nvchad.configs.lspconfig")
nvlsp.defaults()
-- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
-- vim.lsp.set_log_level("debug")

require("mason").setup()
local lspconfig = require("lspconfig")

-- local efmls_config = require("configs.efm")
local servers = {
	marksman = {}, -- markdown

	-- efm=vim.tbl_extend("force", efmls_config, {
	-- 	efmls_config,
	-- }),

	r_language_server = { -- R
		settings = {
			diagnostics = true,
			lint_cache = true,
		},
		flags = { debounce_text_changes = 200 },
	},

	basedpyright = { -- python
		root_dir = function(fname)
			local root_files = {
				"pyproject.toml",
				"setup.py",
				"setup.cfg",
				"requirements.txt",
				"Pipfile",
				"pyrightconfig.json",
				".git",
			}
			local primary = lspconfig.util.root_pattern(unpack(root_files))(fname)
			local fallback = vim.fn.getcwd()
			return primary or fallback
		end,
		single_file_support = true,
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
	},
}

for name, opts in pairs(servers) do
	opts.on_init = nvlsp.on_init
	opts.on_attach = nvlsp.on_attach
	opts.capabilities = nvlsp.capabilities

	lspconfig[name].setup(opts)
end
