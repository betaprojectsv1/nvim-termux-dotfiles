-- Requiere los módulos de configuración individuales
local rust_config = require("lsp.rust")
local python_config = require("lsp.python")

-- Carga el plugin principal y otras dependencias que ya tienes
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind.nvim",
        "j-hui/fidget.nvim",
    },
    config = function()
        -- Importa los módulos necesarios
        local lspconfig = require("lspconfig")
        local cmp = require("cmp")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local luasnip = require("luasnip") 

        -- Configura los servidores de lenguaje utilizando las configuraciones importadas
        lspconfig.rust_analyzer.setup(rust_config)
        lspconfig.pyright.setup(python_config)

        -- Configuración de lspkind para iconos (opcional)
        require("lspkind").setup({})
        
        -- Configuración de fidget.nvim (para notificaciones)
        require("fidget").setup({})

        -- Nivel de log del LSP para depuración (opcional)
        vim.lsp.set_log_level("debug")
    end,
}
