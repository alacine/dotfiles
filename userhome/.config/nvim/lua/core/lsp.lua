local keymap = vim.keymap -- for conciseness

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, silent = true }

    -- set keybinds
    opts.desc = "LSP: Goto definitions"
    --keymap.set("n", "gd", "<CMD>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
    keymap.set("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, opts)

    opts.desc = "LSP: Goto declaration"
    -- keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
    keymap.set("n", "gD", function()
      Snacks.picker.lsp_declarations()
    end, opts)

    opts.desc = "LSP: Show references"
    -- keymap.set("n", "gr", "<CMD>Telescope lsp_references<CR>", opts) -- show definition, references
    keymap.set("n", "gr", function()
      Snacks.picker.lsp_references()
    end, { nowait = true, desc = "References", buffer = ev.buf })

    opts.desc = "LSP: Show implementations"
    -- keymap.set("n", "gi", "<CMD>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
    keymap.set("n", "gI", function()
      Snacks.picker.lsp_implementations()
    end, opts)

    opts.desc = "LSP: Show type definitions"
    -- keymap.set("n", "gt", "<CMD>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
    keymap.set("n", "gt", function()
      Snacks.picker.lsp_type_definitions()
    end, opts)

    opts.desc = "LSP: Show Symbols"
    keymap.set("n", "gs", function()
      Snacks.picker.lsp_symbols()
    end, opts)

    opts.desc = "LSP: Show Workspace Symbols"
    keymap.set("n", "gws", function()
      Snacks.picker.lsp_workspace_symbols()
    end, opts)

    opts.desc = "LSP: See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

    opts.desc = "LSP: Smart rename"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

    opts.desc = "LSP: Show buffer diagnostics"
    keymap.set("n", "<space>d", "<CMD>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

    opts.desc = "LSP: Show line diagnostics"
    keymap.set("n", "<space>l", vim.diagnostic.open_float, opts) -- show diagnostics for line

    opts.desc = "LSP: Go to previous diagnostic"
    keymap.set("n", "[g", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

    opts.desc = "LSP: Go to next diagnostic"
    keymap.set("n", "]g", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

    opts.desc = "LSP: Show documentation under cursor"
    keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

    opts.desc = "LSP: Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
  end,
})

vim.diagnostic.config({
  -- virtual_lines = true,
  -- virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})

vim.lsp.config["gopls"] = {
  cmd = { "gopls" },
  filetype = { "go", "gomod", "gowork", "gotmpl" },
}
--vim.lsp.enable("gopls")
