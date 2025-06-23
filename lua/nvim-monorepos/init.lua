---nvim-monorepos: A simple file picker for monorepo projects
---Finds files matching specific patterns in subdirectories and lists them using telescope.nvim

local config = require("nvim-monorepos.config")
local scanner = require("nvim-monorepos.scanner")
local picker = require("nvim-monorepos.picker")
local commands = require("nvim-monorepos.commands")

local M = {}

---@type string[]|nil
local project_directories = nil
---@type table|nil
local plugin_config = nil

---Find files in a selected project directory
M.find_files = function()
  if not project_directories or #project_directories == 0 then
    vim.notify("nvim-monorepos: No project directories found. Run setup first.", vim.log.levels.WARN)
    return
  end
  picker.show_project_picker(project_directories, "find_files", plugin_config)
end

---Search text in files within a selected project directory
M.find_in_files = function()
  if not project_directories or #project_directories == 0 then
    vim.notify("nvim-monorepos: No project directories found. Run setup first.", vim.log.levels.WARN)
    return
  end
  picker.show_project_picker(project_directories, "find_in_files", plugin_config)
end

---Setup the plugin with user configuration
---@param user_opts table? Optional configuration table
---@field user_opts.files string[]? File patterns to search for (default: {"project.json", "package.json"})
---@field user_opts.ignore string[]? Directory patterns to ignore (default: {".git", "node_modules", "build"})
M.setup = function(user_opts)
  -- Get current working directory as the root for scanning
  local root_directory = vim.fn.getcwd()
  
  -- Setup configuration with user options
  plugin_config = config.setup(user_opts)
  
  -- Find all project directories based on configuration
  project_directories = scanner.find_project_directories(root_directory, plugin_config)
  
  -- Setup user commands
  commands.setup_commands(project_directories, plugin_config)
  
  -- Provide feedback about found projects
  if #project_directories == 0 then
    vim.notify("nvim-monorepos: No project directories found with the specified file patterns", vim.log.levels.WARN)
  else
    vim.notify(string.format("nvim-monorepos: Found %d project directories", #project_directories), vim.log.levels.INFO)
  end
end

return M
