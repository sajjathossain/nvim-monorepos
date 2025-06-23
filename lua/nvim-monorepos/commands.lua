---User command definitions for nvim-monorepos
local M = {}

local picker = require("nvim-monorepos.picker")

---@type string[]|nil
local project_directories = nil
---@type table|nil
local plugin_config = nil

---Create user commands for the plugin
---@param directories string[] List of project directories
---@param config table Plugin configuration
M.setup_commands = function(directories, config)
  project_directories = directories
  plugin_config = config
  
  vim.api.nvim_create_user_command("FindFilesInAProject", function()
    if not project_directories or #project_directories == 0 then
      vim.notify("nvim-monorepos: No project directories found. Run setup first.", vim.log.levels.WARN)
      return
    end
    picker.show_project_picker(project_directories, "find_files", plugin_config)
  end, {
    desc = "Find files in a monorepo project"
  })
  
  vim.api.nvim_create_user_command("FindInFilesInAProject", function()
    if not project_directories or #project_directories == 0 then
      vim.notify("nvim-monorepos: No project directories found. Run setup first.", vim.log.levels.WARN)
      return
    end
    picker.show_project_picker(project_directories, "find_in_files", plugin_config)
  end, {
    desc = "Search text in files within a monorepo project"
  })
end

return M
