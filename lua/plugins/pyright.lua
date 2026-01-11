return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    opts.servers.pyright = opts.servers.pyright or {}
    opts.servers.pyright.settings = vim.tbl_deep_extend(
      "force",
      opts.servers.pyright.settings or {},
      require("config.lsp.python").settings
    )
  end,
  init = function()
    require("config.lsp.python").setup_toggle_command()
  end,
}
