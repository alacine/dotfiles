return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    opts = {},
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          dynamic_preview_title = true,
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
            },
          },
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-[>"] = actions.close,
              ["<C-d>"] = actions.close,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<space>f", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<space>g", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<space>b", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set("n", "<space>h", builtin.help_tags, { desc = "Telescope help tags" })
      vim.keymap.set("n", "<space>m", "<CMD>Telescope notify<CR>", { desc = "Telescopt message" })
      vim.keymap.set("n", "<space>s", "<CMD>Telescope aerial<CR>", { desc = "Goto Symbol (Aerial)" })
    end,
  },
}
