-- vim.lsp.set_log_level("debug")
local nvlsp = require("nvchad.configs.lspconfig")
nvlsp.defaults()

-- disable didChangeWatchedFiles
local ok, wf = pcall(require, "vim.lsp._watchfiles")
if ok then
	wf._watchfunc = function()
		return function() end
	end
end

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

	jedi_language_server = {
		completion = {
			resolveEagerly = true,
		},
		diagnostics = { enable = false },
		jediSettings = {
			caseInsensitiveCompletion = false,
		},
	},

	pyright = { -- python
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
			python = {
				reportMissingSuperCall = false,
				disableOrganizeImports = true,
				analysis = {
					autoImportCompletions = false,
					autoSearchPaths = false,
					useLibraryCodeForTypes = true,
					typeCheckingMode = "off",
					stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/stubs",
					logLevel = "Information",
					diagnosticMode = "openFilesOnly",
					diagnosticSeverityOverrides = { "error", "warning" },
				},
			},
		},
	},
}

local disabled_lsp = { "jedi_language_server" }

local disabled_lookup = {}
for _, name in ipairs(disabled_lsp) do
	disabled_lookup[name] = true
end

for name, opts in pairs(servers) do
	if not disabled_lookup[name] then
		opts.on_init = nvlsp.on_init
		opts.on_attach = nvlsp.on_attach
		opts.capabilities = nvlsp.capabilities
		-- opts.capabilities = require("blink.cmp").get_lsp_capabilities(nvlsp.capabilities)

		lspconfig[name].setup(opts)
	end
end
