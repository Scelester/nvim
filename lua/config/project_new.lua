local M = {}

local uv = vim.uv or vim.loop

local base_dirs = {
  { label = "~/ProjectD/", path = "~/ProjectD" },
  { label = "~/MyScripts/", path = "~/MyScripts" },
  { label = "~/MegaSync/", path = "~/Megasync" },
  { label = "~/Desktop/", path = "~/Desktop" },
  { label = "Testspace", path = "/home/scelester/Container/Testspace" },
}

local function normalize(path)
  return vim.fs.normalize(vim.fn.expand(path))
end

local function startswith(str, prefix)
  return str:sub(1, #prefix) == prefix
end

local function select_base_dir(on_choice)
  local items = {}
  for i, dir in ipairs(base_dirs) do
    items[#items + 1] = {
      idx = i,
      label = dir.label,
      path = dir.path,
    }
  end

  if vim.ui and vim.ui.select then
    vim.ui.select(items, {
      prompt = "Select base directory:",
      format_item = function(item)
        return string.format("%d. %s", item.idx, item.label)
      end,
    }, function(choice)
      if not choice then
        on_choice(nil)
        return
      end
      vim.schedule(function()
        on_choice(normalize(choice.path))
      end)
    end)
    return
  end

  local lines = { "Select base directory:" }
  for i, dir in ipairs(base_dirs) do
    table.insert(lines, string.format("%d. %s", i, dir.label))
  end
  table.insert(lines, "")
  local choice = vim.fn.inputlist(lines)
  if choice < 1 or choice > #base_dirs then
    on_choice(nil)
    return
  end
  on_choice(normalize(base_dirs[choice].path))
end

local function prompt_project_path(base)
  local prev_cwd = vim.fn.getcwd()
  local ok = pcall(vim.cmd, "lcd " .. vim.fn.fnameescape(base))
  if not ok then
    return nil
  end

  local input_ok, rel = pcall(vim.fn.input, {
    prompt = "Project path (Tab to complete): ",
    completion = "dir",
  })

  vim.cmd("lcd " .. vim.fn.fnameescape(prev_cwd))

  if not input_ok or not rel then
    return nil
  end

  rel = vim.trim(rel)
  rel = rel:gsub("^%./", "")
  rel = rel:gsub("/+$", "")
  if rel == "" then
    return nil
  end
  return rel
end

local function has_bad_segments(path)
  local parts = vim.split(path, "/", { plain = true, trimempty = true })
  for _, part in ipairs(parts) do
    if part == "." or part == ".." then
      return true
    end
  end
  return false
end

local function resolve_target(base, rel)
  local base_norm = normalize(base):gsub("/+$", "")
  local target = normalize(base_norm .. "/" .. rel)
  local base_prefix = base_norm .. "/"
  if target == base_norm or not startswith(target, base_prefix) then
    return nil, "Project path must be inside the selected base directory."
  end
  return target
end

local function ensure_readme(target)
  local readme = target .. "/README.md"
  if uv.fs_stat(readme) == nil then
    local name = vim.fs.basename(target)
    local ok = vim.fn.writefile({ "# " .. name, "", "Describe your project here." }, readme)
    if ok ~= 0 then
      return nil, "Failed to create README: " .. readme
    end
  end
  return readme
end

local function start_project_flow(base)
  if not base then
    return
  end

  local base_stat = uv.fs_stat(base)
  if not base_stat or base_stat.type ~= "directory" then
    vim.notify("Base directory does not exist: " .. base, vim.log.levels.ERROR)
    return
  end

  local rel = prompt_project_path(base)
  if not rel then
    return
  end
  if rel:match("^/") or rel:match("^~") then
    vim.notify("Use a relative path under the selected base directory.", vim.log.levels.ERROR)
    return
  end
  if has_bad_segments(rel) then
    vim.notify("Relative path cannot include '.' or '..' segments.", vim.log.levels.ERROR)
    return
  end

  local target, err = resolve_target(base, rel)
  if not target then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  if uv.fs_stat(target) ~= nil then
    vim.notify("Project already exists: " .. target, vim.log.levels.ERROR)
    return
  end

  local ok = vim.fn.mkdir(target, "p")
  if ok == 0 then
    vim.notify("Failed to create project: " .. target, vim.log.levels.ERROR)
    return
  end

  local readme, readme_err = ensure_readme(target)
  if not readme then
    vim.notify(readme_err, vim.log.levels.ERROR)
    return
  end

  vim.cmd("cd " .. vim.fn.fnameescape(target))
  vim.cmd("edit " .. vim.fn.fnameescape(readme))
  vim.notify("Created project: " .. target, vim.log.levels.INFO)
end

function M.new_project()
  select_base_dir(start_project_flow)
end

return M
