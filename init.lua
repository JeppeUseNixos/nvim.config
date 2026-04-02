vim.g.mapleader = " "
vim.o.cursorline = true
vim.o.relativenumber = true
vim.o.number = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)

vim.cmd.colorscheme "catppuccin"

vim.lsp.enable({ "lua_ls", "gopls", "tinymist", "nixd", "zls" })

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config('*', {
	capabilities = capabilities,
	root_markers = { ".git" },
})

vim.lsp.config('nixd', {
	capabilities = capabilities,
	settings = {
		nixd = {
			formatting = {
				command = { "alejandra" },
			},
		},
	},
	root_markers = { ".git" },
})

vim.lsp.config("gopls", {
	settings = {
		gopls = {
			analyses = {
				unusedparams = true
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
	capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
	capabilities = capabilities,
})

vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
	float = {
		style = "minimal",
		border = "rounded",
		header = "",
		prefix = "",
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf }

		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover() <cr>", opts)
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition() <cr>", opts)
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration() <cr>", opts)
		vim.keymap.set({ "n", "i" }, "<C-K>", "<cmd>lua vim.lsp.buf.signature_help() <cr>", opts)
		vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename() <cr>", opts)
		vim.keymap.set("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format() <cr>", opts)
		vim.keymap.set("n", "gc", "<cmd>lua vim.lsp.buf.code_action() <cr>", opts)
	end,
})

local cmp = require "cmp"

vim.opt.completeopt = { "menu", "menuone", "noselect" }
cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	}),
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "buffer",  keyword_length = 3 },
	},
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope helt tags" })

local configs = require "nvim-treesitter"
local langs = { "go", "nix", "lua", "vimdoc", "markdown", "sql", "zig" }
vim.api.nvim_create_autocmd("FileType", {
	pattern = langs,
	callback = function()
		vim.treesitter.start()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
