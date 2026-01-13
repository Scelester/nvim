return {
  "ahmedkhalf/project.nvim",
  opts = {
    detection_methods = { "pattern" },
    patterns = { "." }, -- 👈 every folder is a project
    show_hidden = true,
    silent_chdir = true,
  },
}
