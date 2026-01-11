local M = {}

M.settings = {
  python = {
    analysis = {
      typeCheckingMode = "off",
    },
  },
}

function M.setup_toggle_command()
  vim.api.nvim_create_user_command("TogglePyrightType", function()
    local clients = vim.lsp.get_clients({ name = "pyright" })

    for _, client in ipairs(clients) do
      local current = client.settings.python.analysis.typeCheckingMode or "off"

      local new_mode = (current == "off") and "basic" or "off"

      -- 🔑 Update client.settings (NOT client.config.settings)
      client.settings.python.analysis.typeCheckingMode = new_mode

      -- 🔑 Notify Pyright correctly
      client.notify("workspace/didChangeConfiguration", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = new_mode,
            },
          },
        },
      })

      print("Pyright type checking: " .. new_mode)
    end
  end, {})
end

return M
