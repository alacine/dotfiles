return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    require("nvim-treesitter.configs").setup({
      sync_install = true,
      auto_install = false,
      ignore_install = {},
      ensure_installed = {
        "bash",
        "c",
        "rust",
        "go",
        "gomod",
        "gosum",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "cpp",
        "groovy",
        "python",
        "javascript",
        "typescript",
      },
      highlight = {
        enable = true,
      },
    })
  end,
}
