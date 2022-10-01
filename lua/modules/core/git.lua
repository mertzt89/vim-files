local M = {}

function M.register(use)
    -- Git integration
    use({ "tpope/vim-fugitive" })

    -- Git signs
    use({
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                on_attach = function()
                    local gs = package.loaded.gitsigns
                    local wk = require("which-key")

                    wk.register({
                        -- Navigation
                        ["[c"] = {
                            function()
                                if vim.wo.diff then
                                    return "[c"
                                end
                                vim.schedule(function()
                                    gs.prev_hunk()
                                end)
                                return "<Ignore>"
                            end,
                            "Prev. Chunk",
                            expr = true,
                        },
                        ["]c"] = {
                            function()
                                if vim.wo.diff then
                                    return "]c"
                                end
                                vim.schedule(function()
                                    gs.next_hunk()
                                end)
                                return "<Ignore>"
                            end,
                            "Next Chunk",
                            expr = true,
                        },
                        -- Actions
                        ["<leader>h"] = {
                            name = "+Git",
                            s = { "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk", mode = "n" },
                            r = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk", mode = "n" },
                            --
                            S = { gs.stage_buffer, "Stage Buffer" },
                            u = { gs.undo_stage_hunk, "Undo Stage Hunk" },
                            R = { gs.reset_buffer, "Reset Buffer" },
                            p = { gs.preview_hunk, "Preview Hunk" },
                            b = {
                                function()
                                    gs.blame_line({ full = true })
                                end,
                                "Blame Line",
                            },
                            B = { gs.toggle_current_line_blame, "Toggle Current Line Blame" },
                            d = { gs.diffthis, "Diff This" },
                            D = {
                                function()
                                    gs.diffthis("~")
                                end,
                                "Diff This ~",
                            },
                            x = { gs.toggle_deleted, "Toggle Deleted" },
                        },
                    })

                    wk.register({
                        ["<leader>h"] = {
                            s = { "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk", mode = "v" },
                            r = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk", mode = "v" },
                        },
                    })

                    -- Text objects
                    wk.register({
                        ["ih"] = {
                            ":<C-U>Gitsigns select_hunk<CR>",
                            "Select Hunk",
                            mode = "o",
                        },
                    })
                    wk.register({
                        ["ih"] = {
                            ":<C-U>Gitsigns select_hunk<CR>",
                            "Select Hunk",
                            mode = "x",
                        },
                    })
                end,
            })
        end,
    })

end

return M
