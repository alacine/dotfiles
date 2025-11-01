return {
  "mason-org/mason.nvim",
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
    ensure_installed = {
      "basedpyright",
      "json-lsp",
      "lua-language-server",
      "bash-language-server",
      "nomicfoundation-solidity-language-server",
      "shfmt",
      "stylua",
      -- manually install
      -- "gopls",
      -- "rust-analyzer",
    },
  },
}
