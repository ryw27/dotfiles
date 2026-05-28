-- Neo-tree: floating sidebar file explorer.
-- For inline filesystem editing, Oil ("-" keymap in misc.lua) is faster.

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        { "<leader>e", "<cmd>Neotree float focus toggle=true<CR>", desc = "Neo-tree (float)" },
        { "<leader>E", "<cmd>Neotree left focus toggle=true<CR>",  desc = "Neo-tree (left)" },
    },
    opts = {
        filesystem = {
            filtered_items = {
                visible = true,
                hide_gitignored = false,
            },
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
        },
        window = { position = "float" },
        default_component_configs = {
            indent = { with_markers = true },
        },
    },
}
