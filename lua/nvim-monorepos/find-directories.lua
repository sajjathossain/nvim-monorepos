-- Define the function to find root directories with files matching the file pattern
local function findDirectoriesWithFiles(patterns)
  local current_directory = vim.fn.getcwd()
  local directories = {}

  -- Define a helper function to check if a directory has files matching the file patterns
  local function hasFilesMatchingPatterns(directory, file_patterns)
    for _, entry in ipairs(vim.fn.readdir(directory)) do
      if entry ~= '.' and entry ~= '..' then
        local file_path = directory .. '/' .. entry
        if vim.fn.isdirectory(file_path) == 0 then
          for _, pattern in ipairs(file_patterns) do
            if string.match(entry, pattern) then
              return true
            end
          end
        end
      end
    end
    return false
  end

  -- Recursively search for directories that contain files matching the file pattern
  local function searchDirectories(directory)
    if hasFilesMatchingPatterns(directory, patterns.file) then
      table.insert(directories, directory)
    end

    for _, subdirectory in ipairs(vim.fn.readdir(directory)) do
      local subdirectory_path = directory .. '/' .. subdirectory
      if vim.fn.isdirectory(subdirectory_path) == 1 then
        searchDirectories(subdirectory_path)
      end
    end
  end

  searchDirectories(current_directory)

  return directories
end

return findDirectoriesWithFiles
