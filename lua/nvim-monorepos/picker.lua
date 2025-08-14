---Telescope picker for project selection and file operations
local M = {}

local scanner = require("nvim-monorepos.scanner")

---@type boolean, table|nil
local ok_telescope, _ = pcall(require, "telescope")
local ok_actions, actions = pcall(require, "telescope.actions")
local ok_action_state, action_state = pcall(require, "telescope.actions.state")
local ok_finders, finders = pcall(require, "telescope.finders")
local ok_pickers, pickers = pcall(require, "telescope.pickers")
local ok_builtin, builtin = pcall(require, "telescope.builtin")
local ok_sorters, sorters = pcall(require, "telescope.sorters")
local ok_themes, themes = pcall(require, "telescope.themes")

if not ok_telescope or not ok_actions or not ok_action_state or not ok_finders or not ok_pickers or not ok_builtin or not ok_sorters or not ok_themes then
  vim.notify("Telescope is not installed or some modules are missing", vim.log.levels.ERROR)
  return
end

---Create telescope picker for project selection
---@param project_directories string[] List of project directories
---@param action_type "find_files"|"find_in_files" Type of action to perform
---@param config table Plugin configuration with file patterns
M.show_project_picker = function(project_directories, action_type, config)
  if not project_directories or #project_directories == 0 then
    vim.notify("nvim-monorepos: No project directories found", vim.log.levels.WARN)
    return
  end

  local root_directory = vim.fn.getcwd()
  local display_config = config.display or {}

  -- Create display entries mapping display name to full path
  local entries = {}
  local display_items = {}

  for _, directory in ipairs(project_directories) do
    local display_name = scanner.create_display_name(directory, root_directory)
    local project_files = scanner.get_project_files(directory, config.files)

    -- Create a stylized display format based on configuration
    local file_indicators = ""
    if #project_files > 0 then
      if display_config.show_file_count then
        -- Just show count: "frontend/web-app (2 files)"
        file_indicators = string.format(" (%d file%s)", #project_files, #project_files == 1 and "" or "s")
      elseif display_config.show_icons ~= false then
        -- Show icons with file names (default)
        local styled_files = {}
        for _, file in ipairs(project_files) do
          local icon = ""
          if file == "package.json" then
            icon = "📦"
          elseif file == "Cargo.toml" then
            icon = "🦀"
          elseif file == "go.mod" then
            icon = "🐹"
          elseif file == "pom.xml" then
            icon = "☕"
          elseif file == "project.json" then
            icon = "📋"
          elseif file == "tsconfig.json" then
            icon = "🔷"
          elseif file == "composer.json" then
            icon = "🐘"
          elseif file == "requirements.txt" or file == "pyproject.toml" then
            icon = "🐍"
          elseif file == "Gemfile" then
            icon = "💎"
          else
            icon = "📄"
          end
          table.insert(styled_files, icon .. " " .. file)
        end
        file_indicators = " │ " .. table.concat(styled_files, " • ")
      else
        -- Plain text format: "frontend/web-app [package.json, tsconfig.json]"
        file_indicators = " [" .. table.concat(project_files, ", ") .. "]"
      end
    end

    local full_display = display_name .. file_indicators
    table.insert(display_items, full_display)
    entries[full_display] = directory
  end

  local function on_select(prompt_bufnr)
    if not action_state then
      vim.notify("Telescope is not installed or some modules are missing", vim.log.levels.ERROR)
      return
    end

    local state = action_state.get_selected_entry()
    if not state then
      vim.notify("No entry selected", vim.log.levels.WARN)
      return
    end
    local selected = state.value or ""
    local selected_directory = entries[selected]
    local display_name = scanner.create_display_name(selected_directory, root_directory)

    actions.close(prompt_bufnr)

    local title_prefix = display_config.show_icons ~= false and "📁 " or ""
    local search_prefix = display_config.show_icons ~= false and "🔍 " or ""

    if action_type == "find_files" then
      builtin.find_files({
        prompt_title = title_prefix .. "Find files in " .. display_name,
        cwd = selected_directory
      })
    elseif action_type == "find_in_files" then
      builtin.live_grep({
        prompt_title = search_prefix .. "Find in files in " .. display_name,
        cwd = selected_directory
      })
    end
  end

  local function attach_mappings(_, map)
    map("i", "<CR>", on_select)
    map("n", "<CR>", on_select)
    return true
  end

  local finder = finders.new_table({
    results = display_items,
    entry_maker = function(entry)
      return {
        value = entry,
        display = entry,
        ordinal = entry,
      }
    end
  })

  local title_prefix = display_config.show_icons ~= false and "🚀 " or ""

  pickers.new({}, themes.get_dropdown({
    finder = finder,
    prompt_title = title_prefix .. "Select Project",
    sorter = sorters.get_fzy_sorter(),
    attach_mappings = attach_mappings,
  })):find()
end

return M
