return {
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup({
        nextls = { enable = true }, -- The modern, fast LSP
        elixirls = {
          enable = true,
          settings = elixirls.settings({
            dialyzerEnabled = true,
            fetchDeps = false,
          }),
        },
        projectionist = { enable = true }, -- Helps jump between code and tests
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
