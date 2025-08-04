-- ~/.config/nvim/lua/plugins/lsp/ccls.lua

local on_attach = function(client, bufnr)
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap = true, silent = true }

  -- Mapeos de teclado comunes del LSP para C/C++
  buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

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
  on_attach = on_attach,
  -- Descomenta y usa esta línea con la ruta correcta
  cmd = { "/data/data/com.termux/files/usr/bin/ccls" },
  init_options = {
    compilationDatabaseDirectory = "build",
  }
}
