return {
    
    {
        "neovim/nvim-lspconfig", -- Main Plugin
        dependencies = {
            -- Autocomplete
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            -- Advanced UI plugins
            "onsails/lspkind.nvim",
            "j-hui/fidget.nvim",
        },
        config = function()
            -- Importa los módulos necesarios
            local lspconfig = require("lspconfig")
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- Configuración de nvim-cmp (motor de autocompletado)
            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end, },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, -- Fuente principal de autocompletado (desde LSP)
                    { name = "luasnip" },  -- Fuente de autocompletado (desde snippets)
                    { name = "buffer" },   -- Autocompletado de palabras en el buffer actual
                    { name = "path" },     -- Autocompletado de rutas de archivo
                }),
            })
            -- Configuración de lspkind y fidget
            require("lspkind").setup({})
            require("fidget").setup({})
            vim.lsp.set_log_level("debug")

            -- *** Carga las configuraciones de los servidores de lenguaje desde sus archivos modulares ***
            local rust_config = require("plugins.lsp.rust")
            local python_config = require("plugins.lsp.python")
            local lua_ls_config = require("plugins.lsp.lua_ls")  
            local ccls_config = require("plugins.lsp.ccls") 

            lspconfig.rust_analyzer.setup(rust_config)
            lspconfig.pyright.setup(python_config)
            lspconfig.lua_ls.setup(lua_ls_config)
            lspconfig.ccls.setup(ccls_config)

        end,
    },
}

