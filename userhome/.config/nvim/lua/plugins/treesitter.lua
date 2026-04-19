-- nvim-treesitter main branch (nvim 0.12+):
--   - `nvim-treesitter.configs` removed, use `require("nvim-treesitter").setup()`
--   - `setup()` only handles `install_dir`, not `ensure_installed`
--   - highlighting/indent/folds must be enabled manually via FileType autocmd
--   - parsers compiled from source, requires: `brew install tree-sitter-cli`
--   - auto-install: only for languages in the list below (async, takes effect on next open)
local langs = {
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
}

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()
    local lang_set = {}
    for _, l in ipairs(langs) do
      lang_set[l] = true
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
        if not lang or not lang_set[lang] then
          return
        end
        if not pcall(vim.treesitter.start, ev.buf, lang) then
          require("nvim-treesitter.install").install({ lang })
        end
      end,
    })
  end,
}
