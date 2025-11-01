local keymap = vim.keymap -- for conciseness
local lsp_prefix = "LSP: "

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, silent = true }

    -- set keybinds
    opts.desc = lsp_prefix .. "Goto definitions"
    --keymap.set("n", "gd", "<CMD>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
    keymap.set("n", "gd", function()
      Snacks.picker.lsp_definitions({ focus = "list" })
    end, opts)

    opts.desc = lsp_prefix .. "Goto declaration"
    -- keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
    keymap.set("n", "gD", function()
      Snacks.picker.lsp_declarations({ focus = "list" })
    end, opts)

    opts.desc = lsp_prefix .. "Show references"
    -- keymap.set("n", "gr", "<CMD>Telescope lsp_references<CR>", opts) -- show definition, references
    keymap.set("n", "gr", function()
      Snacks.picker.lsp_references({ focus = "list" })
    end, { nowait = true, desc = "References", buffer = ev.buf })

    opts.desc = lsp_prefix .. "Show implementations"
    -- keymap.set("n", "gi", "<CMD>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
    keymap.set("n", "gI", function()
      Snacks.picker.lsp_implementations({ focus = "list" })
    end, opts)

    opts.desc = lsp_prefix .. "Show type definitions"
    -- keymap.set("n", "gt", "<CMD>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
    keymap.set("n", "gt", function()
      Snacks.picker.lsp_type_definitions({ focus = "list" })
    end, opts)

    opts.desc = lsp_prefix .. "Show Symbols"
    keymap.set("n", "gs", function()
      Snacks.picker.lsp_symbols({ focus = "list" })
    end, opts)

    opts.desc = lsp_prefix .. "Show Workspace Symbols"
    keymap.set("n", "gws", function()
      Snacks.picker.lsp_workspace_symbols({ focus = "list" })
    end, opts)

    opts.desc = lsp_prefix .. "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

    opts.desc = lsp_prefix .. "Smart rename"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

    opts.desc = lsp_prefix .. "Show buffer diagnostics"
    keymap.set("n", "gF", "<CMD>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

    opts.desc = lsp_prefix .. "Show line diagnostics"
    keymap.set("n", "gl", vim.diagnostic.open_float, opts) -- show diagnostics for line

    opts.desc = lsp_prefix .. "Go to previous diagnostic"
    keymap.set("n", "[g", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

    opts.desc = lsp_prefix .. "Go to next diagnostic"
    keymap.set("n", "]g", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

    opts.desc = lsp_prefix .. "Show documentation under cursor"
    keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

    opts.desc = lsp_prefix .. "Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- Inlay hint
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      -- vim.lsp.inlay_hint.enable()
      vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
      end, { buffer = ev.buf, desc = lsp_prefix .. "Toggle Inlay Hints" })
    end

    -- folding
    if client and client.supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    -- Highlight words under cursor
    if
      client
      and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
      and vim.bo.filetype ~= "bigfile"
    then
      local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = ev.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = ev.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(ev2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = ev2.buf })
          -- vim.cmd 'setl foldexpr <'
        end,
      })
    end
  end,
})

-- TODO: Temporarily export lsp config to global,
-- because we need to run vim.diagnostic.config(local_config) manually
-- since go.nvim modifies lsp config unexpectly.
local local_lsp_config = {
  virtual_lines = false,
  virtual_text = false,
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
}

vim.diagnostic.config(local_lsp_config)

vim.lsp.enable({
  "lua_ls",
  "gopls",
  "golangci_lint_ls",
  "basedpyright",
  "rust_analyer",
  "bashls",
  "jsonls",
  "solidity_ls_nomicfoundation",
  "tinymist",
})
