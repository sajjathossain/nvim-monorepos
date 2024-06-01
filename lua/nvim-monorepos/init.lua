local status_ok, utils = pcall(require, "nvim-monorepos.utils")
local status_ok_method, methods = pcall(require, "nvim-monorepos.methods")
local status_ok_customcmds, customcmds = pcall(require, "nvim-monorepos.custom-commands")

if not status_ok or not status_ok_method or not status_ok_customcmds then return end

local initial_directory = nil
local root_directories_with_files = {}
local M = {}

M.find_files = methods.find_files(root_directories_with_files)
M.find_in_files = methods.find_in_files(root_directories_with_files)

--- @param options (table)? [optional] file name
M.setup = function(options)
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

return M
