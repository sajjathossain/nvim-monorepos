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

  local files = options.files
  local ignore = options.ignore
  local root = options.root


  local patterns = {
    files = { "project.json", "package.json" }, -- Replace with your file patterns
    ignore = { ".git", "node_modules", "build" },
    root = {}
  }

  if files and #files > 0 then
    patterns["files"] = files
  end

  if ignore and #ignore > 0 then
    patterns["ignore"] = ignore
  end

  if root and #root > 0 then
    patterns["root"] = root
  end

  local dirs = utils.find_subdirectories(initial_directory, patterns.ignore)
  local subdirs = utils.filterDirectoriesWithPatterns(dirs, patterns.files)
  root_directories_with_files = subdirs
  customcmds.init(root_directories_with_files)
end

return {
  setup = setup,
  show_projects = methods.show_projects(root_directories_with_files)
}
