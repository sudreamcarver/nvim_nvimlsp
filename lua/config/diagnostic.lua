print("✅ Loading core diagnostics config...")

-- 1. 设置诊断图标
local signs = {
    Error = " ",
    Warn  = " ",
    Hint  = " ",
    Info  = " ",
}

vim.diagnostic.config({
    signs = {
        active = signs,
    },
    underline = true,
    undateline = true,
    severity_sort = true,
})

-- 2. 设置悬停浮窗 (CursorHold)
vim.o.updatetime = 300 -- 默认 4000ms 太久了
local group = vim.api.nvim_create_augroup("CoreDiagnosticsAutocmds", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
    group = group,
    callback = function()
        vim.diagnostic.open_float(nil, {
            focusable = false,
            scope = "cursor",
            border = "rounded",
            source = "always",
        })
    end,
})
