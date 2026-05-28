-- =============================================================================
-- General keymaps (no plugin-specific bindings live here).
-- Plugin keymaps live with their respective plugin specs
-- =============================================================================

local map = vim.keymap.set

-- ── Navigation: keep cursor centered ────────────────────────────────────────
-- Don't need these first two with smooth scrolling from snacks.nvim
-- map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down (centered)" })
-- map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up (centered)" })
-- This isn't scrolling, need to keep
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- ── Yank / paste / delete ──────────────────────────────────────
map("n", "<leader>d", '"_d', { desc = "Delete without copying operator" })
map("n", "<leader>p", '"_dP', { desc = "Paste replace without yanking" })
map("x", "<leader>p", [["_dP]], { desc = "Paste over selection without yanking" })
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map({ "n", "v" }, "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- ── Visual mode ─────────────────────────────────────────────
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor in place on join.
map("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })

-- ── Diagnostics navigation ──────────────────
map("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })
map("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Prev diagnostic" })
map("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Single Diagnostic float" })

-- Dump all diagnostics (warning+) into the quickfix list so you can
-- :cdo / batch-edit across every file the LSPs and linters have flagged.
map("n", "<leader>xd", function()
	vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.WARN } })
end, { desc = "Diagnostics → qflist" })

-- ── Buffer / quickfix navigation ────────────────────────────────────────────
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprev<CR>", { desc = "Prev buffer" })

map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Prev quickfix" })

-- ── Project navigation ────────────────────────────────────────────
map("n", "<leader>cd", "<cmd>lcd %:p:h<CR>", { desc = "Make current open project working dir" })

-- =============================================================================
-- Autocommands
-- =============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Briefly highlight yanked region.
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Prose-friendly defaults + list continuation for markdown/text/gitcommit.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
		vim.opt_local.formatoptions:append("j")
		vim.opt_local.formatoptions:remove("t") -- don't hard-wrap prose
	end,
})

-- Close help/qf/man/checkhealth/etc. with q.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = {
		"help",
		"qf",
		"man",
		"lspinfo",
		"checkhealth",
		"notify",
		"noice",
		"spectre_panel",
		"startuptime",
		"neotest-output",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(ev)
		vim.bo[ev.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
	end,
})

-- ── Per-filetype `makeprg` ─────────────────────────────────────────────────
-- Set the project-wide linter / build command per language so <leader>cm
-- runs the right thing. Output goes through vim's default errorformat
-- (which already understands gcc/clang/go/rust/typescript output), so qflist
-- gets populated automatically.
-- TODO: Check if this works
local function set_make(ft, prg, fmt)
	vim.api.nvim_create_autocmd("FileType", {
		group = augroup,
		pattern = ft,
		callback = function()
			vim.opt_local.makeprg = prg
			if fmt then
				vim.opt_local.errorformat = fmt
			end
		end,
	})
end

set_make("go", "golangci-lint run ./...")
set_make("rust", "cargo clippy --workspace --all-targets")
set_make("python", "ruff check .")
set_make({ "javascript", "javascriptreact", "typescript", "typescriptreact" }, "eslint . --format unix")
set_make("sh", "shellcheck %")
set_make("lua", "selene .")

-- C / C++: prefer CMake build dir, fall back to plain Makefile.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "c", "cpp" },
	callback = function()
		if vim.uv.fs_stat("build/CMakeCache.txt") then
			vim.opt_local.makeprg = "cmake --build build -j"
		elseif vim.uv.fs_stat("Makefile") then
			vim.opt_local.makeprg = "make -k -j"
		else
			vim.opt_local.makeprg = "cmake --build build -j" -- safe default
		end
	end,
})
