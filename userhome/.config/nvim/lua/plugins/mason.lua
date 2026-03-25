return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "basedpyright",
        "json-lsp",
        "nomicfoundation-solidity-language-server",
        "vtsls",
        "superhtml",
        "shfmt",
        "stylua",
        -- installed via PKGBUILD-cli
        -- "lua-language-server",
        -- "bash-language-server",
        -- "tinymist",
        -- "ruby-lsp",
        -- "terraform-ls",
        -- installed via go/cargo toolchain
        -- "gopls",
        -- "rust-analyzer",
      },
    },
  },
}
