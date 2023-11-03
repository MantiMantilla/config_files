-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- vim options
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.relativenumber = true
vim.diagnostic.config({
	virtual_text = false,
})
vim.opt.lcs:append({ space = "·" })
vim.opt.list = true

-- -- general
lvim.format_on_save = true
-- lvim.transparent_window = true

-- -- always installed on startup, useful for parsers without a strict filetype
-- vim.list_extend(lvim.builtin.treesitter.ensure_installed, { "python" })

-- lvim.builtin.treesitter.auto_install = true

---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "texlab" })

require("lvim.lsp.manager").setup("sqlls", {
	cmd = { "sql-language-server", "up", "--method", "stdio" },
	filetypes = { "sql", "mysql" },
	root_dir = function()
		return vim.loop.cwd()
	end,
})

-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("ltex", opts)

-- Setup Lsp.
local capabilities = require("lvim.lsp").common_capabilities()
require("lvim.lsp.manager").setup("texlab", {
	on_attach = require("lvim.lsp").common_on_attach,
	on_init = require("lvim.lsp").common_on_init,
	capabilities = capabilities,
})

require("lvim.lsp.manager").setup("ltex", {
	on_attach = require("lvim.lsp").common_on_attach,
	on_init = require("lvim.lsp").common_on_init,
	capabilities = capabilities,
})

-- Prevent cwd from changing to project root on startup, can be changed with :ProjectRoot
lvim.builtin.project.manual_mode = true

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--     return server ~= "ltex"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- linters, formatters and code actions <https://www.lunarvim.org/docs/configuration/language-features/linting-and-formatting>
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "black", filetypes = { "python", "py" } },
	{ command = "isort", filetypes = { "python", "py" } },
	-- { command = "autoflake", filetypes = { "python", "py" }, extra_args = { "--remove-all-unused-imports" } },
	{ command = "stylua" },
	{
		command = "prettier",
		extra_args = { "--print-width", "100" },
		filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "css" },
	},
	{ command = "latexindent", filetypes = { "tex" } },
	{ command = "codespell" },
	{ command = "yamlfix", filetypes = { "yml", "yaml" } },
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{
		command = "flake8",
		extra_args = {
			"--max-line-length",
			"88",
			"--select",
			"C,E,F,W,B,B950",
			"--extend-ignore",
			"E203,E501,E704,W503",
		},
		filetypes = { "python" },
	},
	{
		command = "shellcheck",
		args = { "--severity", "warning" },
	},
	{ command = "chktex", filetypes = { "tex" }, args = { "--inputfiles=0" } },
	{ command = "yamllint", filetypes = { "yml", "yaml" } },
	{
		command = "eslint",
		filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	},
})

local code_actions = require("lvim.lsp.null-ls.code_actions")
code_actions.setup({
	{
		exe = "eslint",
		filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	},
	{
		name = "proselint",
	},
})

-- Additional Plugins <https://www.lunarvim.org/docs/configuration/plugins/user-plugins>
lvim.plugins = {
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	{
		"nvim-lua/plenary.nvim",
	},
	{
		"simrat39/symbols-outline.nvim",
		config = function()
			require("symbols-outline").setup()
		end,
	},
	{ "lervag/vimtex" },
}

-- Additional Plugins for Mason-installed packages
local function mason_package_path(package)
	local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
	return path
end

-- depends on package manager / language
local command = "./venv/bin/pip install flake8-bugbear"
vim.fn.jobstart(command, {
	cwd = mason_package_path("flake8"),
})

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })

-- Vimtex configuration.
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_quickfix_enabled = 0

-- Mappings
lvim.builtin.which_key.mappings["C"] = {
	name = "LaTeX",
	d = { "<cmd>VimtexDocPackage<CR>", "Open Doc for package" },
	s = { "<cmd>VimtexStatus<CR>", "Look at the status" },
	a = { "<cmd>VimtexToggleMain<CR>", "Toggle Main" },
	v = { "<cmd>VimtexView<CR>", "View pdf" },
	i = { "<cmd>VimtexInfo<CR>", "Vimtex Info" },
	t = { "<cmd>VimtexTocToggle<CR>", "Toggle TOC" },
	l = {
		name = "Clean",
		l = { "<cmd>VimtexClean<CR>", "Clean Project" },
		c = { "<cmd>VimtexClean<CR>", "Clean Cache" },
	},
	c = {
		name = "Compile",
		c = { "<cmd>VimtexCompile<CR>", "Compile Project" },
		o = {
			"<cmd>VimtexCompileOutput<CR>",
			"Compile Project and Show Output",
		},
		s = { "<cmd>VimtexCompileSS<CR>", "Compile project super fast" },
		e = { "<cmd>VimtexCompileSelected<CR>", "Compile Selected" },
	},
	o = {
		name = "Stop",
		p = { "<cmd>VimtexStop<CR>", "Stop" },
		a = { "<cmd>VimtexStopAll<CR>", "Stop All" },
	},
}

lvim.builtin.which_key.mappings["V"] = {
	name = "View Toggles",
	w = { "<cmd>set wrap! linebreak!<CR>", "Wrap text on word's end" },
	d = { "<cmd>set list!<CR>", "Show whitespace as '·'" },
}

lvim.builtin.which_key.mappings["S"] = { "<cmd>SymbolsOutline<CR>", "Symbols Outline" }
