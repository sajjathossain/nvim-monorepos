local setRootDirectory = require("nvim-monorepos.root")
local utils = require("nvim-monorepos.utils")
local write = require("nvim-monorepos.write").writeOutput
local telescope = require("nvim-monorepos.telescope")

local get_subdirectories = utils.get_subdirectories
local root_directories_with_files = nil
local root = { ".git" }

--[[
  setup function
  @param options (table) [optional] file name
-- ]]
local setup = function(options)
  options = options or {
    patterns = {}
  }
  local filePatterns = options.patterns


  local patterns = {
    file = { "project.json", "package.json", "README.md" }, -- Replace with your file patterns
    ignore = { ".git", "node_modules", "**/build" },
  }

  if filePatterns and #filePatterns > 0 then
    patterns.file = filePatterns
  end

  setRootDirectory()

  local subdirs = get_subdirectories(vim.fn.getcwd(), patterns.ignore, patterns.file)
  root_directories_with_files = subdirs
end

local show_list = function()
  telescope(root_directories_with_files, root)
end

return {
  setup = setup,
  show_list = show_list
}
