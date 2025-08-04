local on_attach = function(client, bufnr)
    
    local buf_set_keymap = vim.api.nvim_buf_set_keymap
    local opts = { noremap = true, silent = true }

    -- Mapeos de teclado para Rust
    buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

    -- Navegación de diagnósticos (errores/advertencias)
    buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

    -- Resaltado automático de referencias y diagnósticos flotantes
    vim.cmd [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
    vim.cmd [[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]]
    vim.cmd [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
    vim.diagnostic.config({
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })
end

return {
    cmd = { "/data/data/com.termux/files/usr/bin/rust-analyzer" },
    settings = {
        ["rust-analyzer"] = {
            check = { command = "clippy" },
            procMacro = { enable = true, },
        },
    },
    on_attach = on_attach,
}


