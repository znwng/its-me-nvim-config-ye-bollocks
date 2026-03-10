return {
    "windwp/nvim-autopairs",

    event = "InsertEnter",

    config = function()
        local ok, npairs = pcall(require, "nvim-autopairs")
        if not ok then
            return
        end

        npairs.setup({
            check_ts = true,
            disable_filetype = { "TelescopePrompt", "vim" },
        })

        local cmp_ok, cmp = pcall(require, "cmp")
        if cmp_ok then
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local handlers = require("nvim-autopairs.completion.handlers")

            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done({
                    filetypes = {
                        python = false,
                        lua = {
                            ["("] = {
                                kind = {
                                    cmp.lsp.CompletionItemKind.Function,
                                    cmp.lsp.CompletionItemKind.Method,
                                },
                                handler = handlers["*"],
                            },
                        },
                    },
                })
            )
        end
    end,
}

