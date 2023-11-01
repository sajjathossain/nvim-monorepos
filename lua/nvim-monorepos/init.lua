local setRootDirectory = require("nvim-monorepos.root")
local findDirectories = require("nvim-monorepos.find-directories")
local write = require("nvim-monorepos.write")
local telescope = require("nvim-monorepos.telescope")

--[[
  setup function
  @param options (table) [optional] file name
-- ]]
local setup = function(options)
  options = options or {
    output = "",
    filePatterns = {}
  }
  local output, filePatterns = options.output, options.filePatterns

  local output_file = "output.txt" -- Replace with the desired output file path
  if output and #output > 0 then
    output_file = output
  end

  -- Usage example
  local patterns = {
    file = { "%.md" }, -- Replace with your file patterns
  }

  if filePatterns and #filePatterns > 0 then
    patterns.file = filePatterns
  end

  local root_directories_with_files = findDirectories(patterns)

  telescope(root_directories_with_files)
  -- write(output_file, root_directories_with_files)

  setRootDirectory()
end

return {
  setup = setup
}
