local utils = require("nvim-monorepos.utils")
local methods = require("nvim-monorepos.methods")
local customcmds = require("nvim-monorepos.custom-commands")

local initial_directory = nil
local root_directories_with_files = {}

--[[
  setup function
  @param options (table) [optional] file name
-- ]]
local setup = function(options)
  initial_directory = vim.fn.getcwd()
  options = options or {
    patterns = {}
  }
  local filePatterns = options.patterns


  local patterns = {
    file = { "project.json", "package.json", "README.*" }, -- Replace with your file patterns
    ignore = { ".git", "node_modules", "build" },
  }

  if filePatterns and #filePatterns > 0 then
    patterns.file = filePatterns
  end


  local dirs = utils.find_subdirectories(initial_directory, patterns.ignore)
  local subdirs = utils.filterDirectoriesWithPatterns(dirs, patterns.file)
  root_directories_with_files = subdirs
  customcmds.init(root_directories_with_files)
end

return {
  setup = setup,
  show_projects = methods.show_projects(root_directories_with_files)
}
