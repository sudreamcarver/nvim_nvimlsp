vim.lsp.enable 'lua_ls'
vim.lsp.enable 'clangd'
vim.lsp.enable 'pyright'

local group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args) -- args.buf, args.data.client_id
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        local opts = { buffer = bufnr, silent = true }
        local km = vim.keymap.set

        -- 根据 server_capabilities 做条件绑定（更兼容多 server 的情况）
        if client.server_capabilities.definitionProvider then
            km("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP: goto definition" }))
        end
        if client.server_capabilities.declarationProvider then
            km("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "LSP: goto declaration" }))
        end
        if client.server_capabilities.implementationProvider then
            km("n", "gi", vim.lsp.buf.implementation, opts)
        end
        if client.server_capabilities.referencesProvider then
            km("n", "gr", vim.lsp.buf.references, opts)
        end
        -- 悬停（hover）
        if client.server_capabilities.hoverProvider then
            km("n", "K", vim.lsp.buf.hover, opts)
        end

        -- 常用操作
        km("n", "<leader>rn", vim.lsp.buf.rename, opts)
        km({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        km("n", "[g", vim.diagnostic.goto_prev, opts)
        km("n", "]g", vim.diagnostic.goto_next, opts)
        km("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
    end,
})


-- 在 lspconfig 或 mason-lspconfig 配置之后放置
vim.api.nvim_create_autocmd("CursorHold", {
    buffer = 0, -- 只在当前 buffer 生效
    callback = function()
        -- 打开诊断浮动窗口（不抢占焦点）
        vim.diagnostic.open_float(nil, {
            focusable = false, -- 不让浮窗抢占光标
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded", -- 浮窗边框样式（可选："single", "double", "rounded"）
            source = "always", -- 总是显示诊断来源
            prefix = " "  -- 浮窗左边留点空格
        })
    end
})
