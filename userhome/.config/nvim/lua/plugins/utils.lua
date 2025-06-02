return {
  {
    "jiangmiao/auto-pairs",
    config = function()
      vim.g.AutoPairsCenterLine = 0
      vim.g.AutoPairsMapCR = 0
    end,
  },
  { "itchyny/vim-cursorword" },
  { "tpope/vim-surround" },
  { "lfv89/vim-interestingwords" },
  { "mg979/vim-visual-multi" },
  { "tpope/vim-fugitive" },
  { "brooth/far.vim" },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<CMD>UndotreeToggle<CR>", desc = "Toggle Undo Tree" },
    },
  },
  {
    "airblade/vim-gitgutter",
    config = function()
      vim.g.gitgutter_highlight_lines = 1
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    ft = "markdown",
  },
  {
    "echasnovski/mini.comment",
    version = false,
    opts = {
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Toggle comment (like `gcip` - comment inner paragraph) for both
        -- Normal and Visual modes
        comment = "<leader>ci",

        -- Toggle comment on current line
        comment_line = "<leader>ci",

        -- Toggle comment on visual selection
        comment_visual = "<leader>ci",

        -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        -- Works also in Visual mode if mapping differs from `comment_visual`
        textobject = "<leader>ci",
      },
    },
  },
}
