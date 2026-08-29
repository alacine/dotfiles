local leetcode_home = vim.fn.expand("~/Code/leetcode")

local function write_if_changed(path, lines)
  local next_text = table.concat(lines, "\n") .. "\n"

  if vim.fn.filereadable(path) == 1 then
    local current_text = table.concat(vim.fn.readfile(path), "\n") .. "\n"
    if current_text == next_text then
      return false
    end
  end

  vim.fn.writefile(lines, path)
  return true
end

local function ensure_go_mod()
  local gomod = leetcode_home .. "/go.mod"
  if vim.fn.filereadable(gomod) == 1 then
    return
  end

  write_if_changed(gomod, {
    "module leetcode",
    "",
    "go 1.26",
  })
end

local function ensure_cargo_toml()
  local manifest = leetcode_home .. "/Cargo.toml"
  if vim.fn.filereadable(manifest) == 1 then
    return
  end

  write_if_changed(manifest, {
    "[package]",
    'name = "leetcode"',
    'version = "0.1.0"',
    'edition = "2024"',
    "",
    "[dependencies]",
  })
end

local function rust_bin_name(question, file)
  local base
  if question and question.q then
    base = ("%s_%s"):format(question.q.frontend_id, question.q.title_slug)
  else
    base = vim.fn.fnamemodify(file, ":t:r")
  end

  local name = base:gsub("[^%w_]", "_")
  if name:match("^%d") then
    return "q_" .. name
  end
  return name
end

local function rust_bin_path(question)
  local config = require("leetcode.config")
  local bin_dir = config.storage.home:joinpath("src"):joinpath("bin")
  vim.fn.mkdir(bin_dir:absolute(), "p")

  local filename = rust_bin_name(question, question.q and question.q.title_slug or nil) .. ".rs"
  return bin_dir:joinpath(filename)
end

local function is_legacy_rust_file(file)
  local relpath = file and vim.fs.relpath(leetcode_home, file)
  return relpath and relpath:match("%.rs$") and not relpath:find("/", 1, true) and not relpath:match("^%.%./")
end

local function has_line(lines, pattern)
  for _, line in ipairs(lines) do
    if line:match(pattern) then
      return true
    end
  end
  return false
end

local function wrap_rust_bin(lines)
  local has_solution = has_line(lines, "^%s*pub%s+struct%s+Solution%s*;")
  local has_main = has_line(lines, "^%s*fn%s+main%s*%(")

  if has_solution and has_main then
    return lines
  end

  local wrapped = {}
  if not has_solution then
    vim.list_extend(wrapped, { "pub struct Solution;", "" })
  end

  vim.list_extend(wrapped, lines)

  if not has_main then
    vim.list_extend(wrapped, { "", "fn main() {}" })
  end

  return wrapped
end

local function patch_leetcode_rust_path()
  local Question = require("leetcode-ui.question")
  if Question._dotfiles_rust_bin_path_patched then
    return
  end

  local original_path = Question.path
  Question.path = function(question)
    if question.lang ~= "rust" then
      return original_path(question)
    end

    question.file = rust_bin_path(question)
    local existed = question.file:exists()

    if not existed then
      question.file:write(table.concat(wrap_rust_bin(vim.split(question:snippet(), "\n")), "\n"), "w")
    end

    return question.file:absolute(), existed
  end

  Question._dotfiles_rust_bin_path_patched = true
end

local function ensure_rust_bin(question)
  ensure_cargo_toml()

  local src_bin_dir = leetcode_home .. "/src/bin"
  vim.fn.mkdir(src_bin_dir, "p")

  local bufnr = question.bufnr
  if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
    return false
  end

  local current_file = vim.api.nvim_buf_get_name(bufnr)
  local bin_path = ("%s/%s.rs"):format(src_bin_dir, rust_bin_name(question, current_file))
  local legacy_file = is_legacy_rust_file(current_file) and current_file or nil
  local lines

  if vim.fn.filereadable(bin_path) == 1 then
    lines = wrap_rust_bin(vim.fn.readfile(bin_path))
  else
    lines = wrap_rust_bin(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false))
  end

  local changed = write_if_changed(bin_path, lines)

  if current_file ~= bin_path then
    vim.api.nvim_buf_set_name(bufnr, bin_path)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.bo[bufnr].modified = false
  end

  if legacy_file then
    vim.fn.delete(legacy_file)
  end

  return changed or current_file ~= bin_path
end

local function reload_rust_workspace()
  vim.schedule(function()
    for _, client in ipairs(vim.lsp.get_clients({ name = "rust_analyzer" })) do
      client:request("rust-analyzer/reloadWorkspace", nil, function(err)
        if err then
          vim.notify(tostring(err), vim.log.levels.ERROR)
        end
      end)
    end
  end)
end

return {
  "kawre/leetcode.nvim",
  cmd = "Leet",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    lang = "rust",
    storage = {
      home = leetcode_home,
      cache = vim.fn.stdpath("cache") .. "/leetcode",
    },
    cn = {
      enabled = true,
      translator = true,
      translate_problems = true,
    },
    picker = {
      provider = "telescope",
    },
    injector = {
      golang = {
        before = "package main",
      },
    },
    hooks = {
      enter = {
        function()
          patch_leetcode_rust_path()
          vim.fn.mkdir(leetcode_home, "p")
          ensure_go_mod()
          ensure_cargo_toml()
        end,
      },
      question_enter = {
        function(question)
          if question.lang ~= "rust" then
            return
          end

          if ensure_rust_bin(question) then
            reload_rust_workspace()
          end
        end,
      },
    },
  },
  keys = {
    { "<leader>ll", "<cmd>Leet list<cr>", desc = "LeetCode list" },
    { "<leader>ld", "<cmd>Leet daily<cr>", desc = "LeetCode daily" },
    { "<leader>lr", "<cmd>Leet run<cr>", desc = "LeetCode run" },
    { "<leader>ls", "<cmd>Leet submit<cr>", desc = "LeetCode submit" },
    { "<leader>lc", "<cmd>Leet console<cr>", desc = "LeetCode console" },
    { "<leader>li", "<cmd>Leet info<cr>", desc = "LeetCode info" },
    { "<leader>lg", "<cmd>Leet lang<cr>", desc = "LeetCode language" },
  },
}
