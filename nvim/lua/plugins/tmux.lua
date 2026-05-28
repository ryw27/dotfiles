-- vim-tmux-navigator: moves between vim splits
-- AND tmux panes when run inside tmux. Outside tmux it just moves
-- between vim splits.

return {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
        "TmuxNavigatorProcessList",
    },
    keys = {
        { "<C-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>",     desc = "Window/pane left" },
        { "<C-j>",  "<cmd><C-U>TmuxNavigateDown<cr>",     desc = "Window/pane down" },
        { "<C-k>",  "<cmd><C-U>TmuxNavigateUp<cr>",       desc = "Window/pane up" },
        { "<C-l>",  "<cmd><C-U>TmuxNavigateRight<cr>",    desc = "Window/pane right" },
        { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Window/pane previous" },
    },
}
