return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- Add file
    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "Harpoon add file" })

    -- Toggle quick menu
    vim.keymap.set("n", "<leader>h", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon menu" })

    -- Jump to files 1–5
    for i = 1, 5 do
      vim.keymap.set("n", "<leader>" .. i, function()
        harpoon:list():select(i)
      end, { desc = "Harpoon file " .. i })
    end
  end,
}
