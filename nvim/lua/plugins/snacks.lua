-- Snacks: lightweight QoL bundle (dashboard, notifier, input, scope guides,
-- smooth scroll, word highlighter).

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- Enable desired modules
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
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
			desc = "Snacks: Find projects",
		},
		{
			"<leader>fz",
			function()
				Snacks.picker.zoxide()
			end,
			desc = "Snacks: Jump to recent dir",
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
