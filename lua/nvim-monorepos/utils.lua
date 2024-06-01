local M = {}
--- get the last part of the directory string
--- @param directoryPath (string) path of the directory
M.get_last_part_of_directory = function(directoryPath)
  -- Extract the last part of the directory path
  local lastPart = vim.fn.fnamemodify(directoryPath, ':t')
  return lastPart or ""
end

-- filter directory
local filterDirectory = function(path, ignorePatterns)
  local shouldKeep = true
  for _, pattern in ipairs(ignorePatterns) do
    if string.match(path, pattern) then
      shouldKeep = false
      break
    end
  end

  return shouldKeep
end
-- filter directories that matches the ignore pattern
M.filterDirectories = function(directories, ignorePatterns)
  local filteredDirectories = {}
  for _, dir in ipairs(directories) do
    local shouldKeep = true
    for _, pattern in ipairs(ignorePatterns) do
      if string.match(dir, pattern) then
        shouldKeep = false
        break
      end
    end
    if shouldKeep then
      table.insert(filteredDirectories, dir)
    end
  end
  return filteredDirectories
end


-- Function to filter directories
M.filterDirectoriesWithPatterns = function(directories, filePatterns)
  local filteredDirectories = {}

  for _, directory in ipairs(directories) do
    local shouldKeep = false

    for _, pattern in ipairs(filePatterns) do
      local files = vim.fn.readdir(directory)
      local matchesPattern = false

      for _, file in ipairs(files) do
        if vim.fn.glob(pattern, file) == file then
          matchesPattern = true
          break
        end
      end

      if matchesPattern then
        shouldKeep = true
        break
      end
    end

    if shouldKeep then
      table.insert(filteredDirectories, directory)
    end
  end

  return filteredDirectories
end

M.find_subdirectories = function(root_directory, ignorePatterns)
  local subdirectories = {}

  local function find_subdirectories_recursive(directory)
    local items = vim.fn.readdir(directory)

    for _, item in ipairs(items) do
      if filterDirectory(directory, ignorePatterns) then
        local path = directory .. '/' .. item
        local is_directory = vim.fn.isdirectory(path)
        if is_directory == 1 and item ~= '.' and item ~= '..' then
          table.insert(subdirectories, path)
          find_subdirectories_recursive(path)
        end
      end
    end
  end

  find_subdirectories_recursive(root_directory)

  return subdirectories
end

return M
