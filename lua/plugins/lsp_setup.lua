return {
  {
    "neovim/nvim-lspconfig", -- El plugin principal para configurar LSPs
    dependencies = {
      -- Motor de autocompletado y sus fuentes
      "hrsh7th/nvim-cmp",      -- El motor de autocompletado
      "hrsh7th/cmp-nvim-lsp",  -- Fuente de nvim-cmp para sugerencias del LSP
      "L3MON4D3/LuaSnip",      -- Para snippets (requerido por cmp-nvim-lsp)
      "saadparwaiz1/cmp_luasnip", -- Fuente de nvim-cmp para snippets de LuaSnip

      -- Mejoras visuales y de UX (opcionales pero muy recomendadas)
      "onsails/lspkind.nvim",  -- Para iconos en el autocompletado (requiere Nerd Fonts)
      "j-hui/fidget.nvim",     -- Para notificaciones de progreso del LSP
    },
    config = function()
      -- Importa los módulos necesarios
      local lspconfig = require("lspconfig")
      local cmp = require("cmp")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local luasnip = require("luasnip")

      -- Configuración de rust_analyzer
      lspconfig.rust_analyzer.setup({
        -- *** RUTA CRUCIAL: Asegúrate de que esta sea la ruta correcta en tu Termux ***
        cmd = { "/data/data/com.termux/files/usr/bin/rust-analyzer" },
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy", extraArgs = { "--workspace" }, },
            procMacro = { enable = true, },
          },
        },
        on_attach = function(client, bufnr)
          -- Aquí van los mapeos de teclado comunes del LSP
          local buf_set_keymap = vim.api.nvim_buf_set_keymap
          local opts = { noremap = true, silent = true }

          -- Navegación y acciones LSP
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
        end,
      })

      -- Configuración de lua_ls (para archivos Lua, como tu configuración de Neovim)
      -- Ajusta la ruta 'cmd' si tu lua-language-server está en un lugar diferente
      lspconfig.lua_ls.setup({
        cmd = { "/data/data/com.termux/files/usr/bin/lua-language-server" }, -- O tu ruta si es diferente
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim', 'it', 'describe', 'before_each', 'after_each' }, -- Añade globales si usas marcos de prueba
            },
          },
        },
        on_attach = function(client, bufnr)
          -- Puedes usar los mismos mapeos que para rust_analyzer o personalizar
          local buf_set_keymap = vim.api.nvim_buf_set_keymap
          local opts = { noremap = true, silent = true }
          buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          -- etc.
        end,
      })

      -- Configuración de nvim-cmp (motor de autocompletado)
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end, },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),      -- Activa el autocompletado manualmente
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirma la selección
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), -- Siguiente sugerencia
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), -- Sugerencia anterior
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },   -- Fuente principal de autocompletado (desde LSP)
          { name = "luasnip" },    -- Fuente de autocompletado (desde snippets)
          { name = "buffer" },     -- Autocompletado de palabras en el buffer actual
          { name = "path" },       -- Autocompletado de rutas de archivo
        }),
      })

      -- Configuración de lspkind para iconos (opcional)
      require("lspkind").setup({})

      -- Configuración de fidget.nvim (para notificaciones de LSP)
      require("fidget").setup({})

      -- Nivel de log del LSP para depuración (opcional, puedes borrarlo luego)
      vim.lsp.set_log_level("debug")

    end, -- Fin de la función config del plugin nvim-lspconfig
  }, -- Fin de la definición del plugin nvim-lspconfig
}
