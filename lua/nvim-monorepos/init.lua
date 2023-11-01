local setRootDirectory = require("nvim-monorepos.root")
local findDirectories = require("nvim-monorepos.find-directories")
local telescope = require("nvim-monorepos.telescope")

local root_directories_with_files = nil

--[[
  setup function
  @param options (table) [optional] file name
-- ]]
local setup = function(options)
  options = options or {
    patterns = {}
  }
  local filePatterns = options.patterns


  -- Usage example
  local patterns = {
    file = { "project.json" },  -- Replace with your file patterns
    ignore = { ".git.*", "node_modules.*" },
    dir = { "apps.*", "packages.*" }
  }

  if filePatterns and #filePatterns > 0 then
    patterns.file = filePatterns
  end

  root_directories_with_files = findDirectories(patterns.file, patterns.dir, patterns.ignore)

  setRootDirectory()
end

local show_list = function()
  telescope(root_directories_with_files)
end

return {
  setup = setup,
  show_list = show_list
}
