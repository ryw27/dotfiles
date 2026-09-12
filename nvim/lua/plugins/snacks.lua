-- Snacks: lightweight QoL bundle (dashboard, notifier, input, scope guides,
-- smooth scroll, word highlighter).

-- ~/.config/nvim is a symlink farm into ~/dotfiles/nvim; resolve so file
-- pickers see real files 
local function nvim_config_dir()
	return vim.fn.fnamemodify(vim.fn.resolve(vim.fn.stdpath("config") .. "/init.lua"), ":h")
end

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- Enable desired modules
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				keys = {
					{
						icon = " ",
						key = "f",
						desc = "Find File",
						action = function()
							require("fzf-lua").files()
						end,
					},
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = function()
							require("fzf-lua").live_grep()
						end,
					},
					{ icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = function()
							require("fzf-lua").oldfiles()
						end,
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = function()
							require("fzf-lua").files({ cwd = nvim_config_dir() })
						end,
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
		},
		explorer = { enabled = false },
		indent = {
			enabled = true,
			char = "│",
			only_scope = false,
			animate = {
				enabled = true,
				style = "out",
			},
		},
		input = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				projects = {
					dev = { "~/programming", "~/dotfiles" },
				},
			},
		},
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		{
			"<leader>nh",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Snacks: Notification history",
		},
		{
			"<leader>nd",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Snacks: Dismiss notifications",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Snacks: Delete buffer (keep window)",
		},
		{
			"<leader>bD",
			function()
				Snacks.bufdelete.all()
			end,
			desc = "Snacks: Delete all buffers",
		},
		{
			"<leader>id",
			function()
				if Snacks.dim.enabled then
					Snacks.dim.disable()
				else
					Snacks.dim.enable()
				end
			end,
			desc = "Snacks: Toggle scope dim",
		},
		{
			"<leader>fP",
			function()
				Snacks.picker.projects()
			end,
			desc = "Find projects",
		},
	},
}

-- preset = {
--     header = {
--         --      [[
--         --                         oooo$$$$$$$$$$$$oooo
--         --                       oo$$$$$$$$$$$$$$$$$$$$$$$$o
--         --                    oo$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o         o$   $$ o$
--         --    o $ oo        o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o       $$ $$ $$o$
--         -- oo $ $ "$      o$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$o       $$$o$$o$
--         -- "$$$$$$o$     o$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$o    $$$$$$$$
--         --   $$$$$$$    $$$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$$$$$$$$$$$$$$
--         --   $$$$$$$$$$$$$$$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$$$$$$  """$$$
--         --    "$$$""""$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     "$$$
--         --     $$$   o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     "$$$o
--         --    o$$"   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$       $$$o
--         --    $$$    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" "$$$$$$ooooo$$$$o
--         --   o$$$oooo$$$$$  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$   o$$$$$$$$$$$$$$$$$
--         --   $$$$$$$$"$$$$   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     $$$$""""""""
--         --  """"       $$$$    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$"      o$$$
--         --             "$$$o     """$$$$$$$$$$$$$$$$$$"$$"         $$$
--         --               $$$o          "$$""$$$$$$""""           o$$$
--         --                $$$$o                 oo             o$$$"
--         --                 "$$$$o      o$$$$$$o"$$$$o        o$$$$
--         --                   "$$$$$oo     ""$$$$o$$$$$o   o$$$$""
--         --                      ""$$$$$oooo  "$$$o$$$$$$$$$"""
--         --                         ""$$$$$$$oo $$$$$$$$$$
--         --                                 """"$$$$$$$$$$$
--         --                                     $$$$$$$$$$$$
--         --                                      $$$$$$$$$$"
--         --                                       "$$$""""
--         --                     ]],
--         --  },
--     },
-- }
