return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>f",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
    {
      "<leader>tf",
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify(("Autoformat on save: %s"):format(vim.g.disable_autoformat and "OFF" or "ON"))
      end,
      mode = "",
      desc = "Toggle autoformat on save",
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      python = {
        -- To fix auto-fixable lint errors.
        "ruff_fix",
        -- To run the Ruff formatter.
        "ruff_format",
        -- Too organize the imports.
        "ruff_organize_imports",
      },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      go = { "goimports", "gofmt" },
      html = { "superhtml" },
      json = { "prettierd", "prettier", stop_after_first = true },
      jsonc = { "prettierd", "prettier", stop_after_first = true },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Set up format-on-save
    format_on_save = function(buffer)
      -- 支持通过变量禁用自动格式化
      if vim.g.disable_autoformat or vim.b[buffer].disable_autoformat then
        return
      end
      return { timeout_ms = 500 }
    end,
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
      prettierd = {
        prepend_args = { "--print-width", "120" },
      },
      prettier = {
        prepend_args = { "--print-width", "120" },
      },
    },
  },
  init = function()
    -- 默认禁用保存时自动格式化
    vim.g.disable_autoformat = false
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    -- 添加用户命令来控制格式化
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! 只禁用当前 buffer
        vim.b.disable_autoformat = true
      else
        -- FormatDisable 全局禁用
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "禁用保存时自动格式化",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "启用保存时自动格式化",
    })
  end,
}
