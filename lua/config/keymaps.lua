-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>yD", function()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

  if #diagnostics == 0 then
    vim.notify("No diagnostics on this line")
    return
  end

  local text = table.concat(vim.tbl_map(function(diagnostic)
    return diagnostic.message
  end, diagnostics), "\n")

vim.fn.setreg("+", text)
  vim.notify("Copied diagnostic")
end, { desc = "Copy diagnostics on current line" })
