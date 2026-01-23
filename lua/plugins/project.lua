return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      detection_methods = { "pattern" },
      patterns = {
        ".project", -- your custom marker
        ".git",
        "package.json",
        "Cargo.toml",
        "go.mod",
        "pyproject.toml",
        "setup.py",
        "requirements.txt",
        "Makefile",
      },
      show_hidden = true,
      silent_chdir = true,
    })
  end,
}
