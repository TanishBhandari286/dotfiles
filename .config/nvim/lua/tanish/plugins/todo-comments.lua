return {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local todo_comments = require("todo-comments")

        -- ... your keymaps are here ...

        todo_comments.setup({
            -- ADD THIS SECTION:
            highlight = {
                -- The keywords below are CASE SENSITIVE
                FIX = {
                    fg = "#DC2626", -- A bright red
                    bg = "#1F2937", -- Your dark background
                    bold = true,
                },
                TODO = {
                    fg = "#3B82F6", -- A bright blue
                    bg = "#1F2937",
                    bold = true,
                },
                NOTE = {
                    fg = "#FBBF24", -- A bright yellow
                    bg = "#1F2937",
                    bold = true,
                },
                -- You can add the others (WARN, HACK, etc.) here
            },
        })
    end,
}
