return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate", 
        event = "VeryLazy", 
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "rust", "lua", "vim", "html", "css", "javascript", "typescript", "json", "yaml" },
                highlight = { enable = true }, 
                indent = { enable = true },  
            })
        end,
    }
}
