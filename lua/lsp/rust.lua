-- La función `on_attach` y la configuración de los diagnósticos
-- es genérica y se puede reutilizar, o poner en una función compartida.
-- Por ahora, la dejamos aquí para simplicidad.
local on_attach = function(client, bufnr)
    local buf_set_keymap = vim.api.nvim_buf_set_keymap
    local opts = { noremap = true, silent = true }

    buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    
    buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    
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

-- Exporta la configuración de `rust_analyzer` como una tabla
return {
    cmd = { "/data/data/com.termux/files/usr/bin/rust-analyzer" },
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = { command = "clippy", extraArgs = { "--", "--no-deps" } },
            procMacro = { enable = true, },
        },
    },
    on_attach = on_attach,
}
