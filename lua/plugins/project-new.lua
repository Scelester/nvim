return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      if not opts.dashboard or not opts.dashboard.preset then
        return
      end

      local keys = opts.dashboard.preset.keys or {}
      table.insert(keys, 3, {
        key = "N",
        desc = "📽️ New Project",
        action = function()
          require("config.project_new").new_project()
        end,
      })
      opts.dashboard.preset.keys = keys
    end,
    keys = {
      {
        "<C-S-n>",
        function()
          require("config.project_new").new_project()
        end,
        desc = "📽️ New Project",
      },
    },
  },
  {
    "goolord/alpha-nvim",
    optional = true,
    opts = function(_, dashboard)
      local button = dashboard.button("p", "New Project", function()
        require("config.project_new").new_project()
      end)
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
      table.insert(dashboard.section.buttons.val, 3, button)
    end,
  },
}
