------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
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

------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------

local function findRootDirectoriesWithFiles(patterns, ignore_patterns)
  local current_directory = vim.fn.getcwd()
  local root_directories = {}

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

  -- Check if the current directory matches any of the directory patterns (regex)
  local function matchesDirectoryPattern(directory, dir_patterns)
    for _, pattern in ipairs(dir_patterns) do
      local regex_pattern = "^" .. pattern .. "$"
      if string.match(directory, regex_pattern) then
        return true
      end
    end
    return false
  end
  -- Check if the current directory matches any of the ignore patterns
  local function matchesIgnorePattern(directory)
    for _, pattern in ipairs(ignore_patterns) do
      local regex_pattern = "^" .. pattern .. "$"
      if string.match(directory, regex_pattern) then
        return true
      end
    end
    return false
  end
  -- Recursively search for root directories that contain files matching the file pattern
  local function searchDirectories(directory)
    if hasFilesMatchingPatterns(directory, patterns.file) and not matchesIgnorePattern(directory) then
      table.insert(root_directories, directory)
    end

    for _, subdirectory in ipairs(vim.fn.readdir(directory)) do
      local subdirectory_path = directory .. '/' .. subdirectory
      if vim.fn.isdirectory(subdirectory_path) == 1 and matchesDirectoryPattern(subdirectory, patterns.dir) then
        searchDirectories(subdirectory_path)
      end
    end
  end

  searchDirectories(current_directory)

  return root_directories
end


------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------


local function findSubdirectoriesWithRootFile(root_files, search_dir_regex, ignore_patterns)
  local current_directory = vim.fn.getcwd()
  local subdirectories = {}

  -- Check if the current directory contains a file in the root directory matching any of the specified regex patterns
  local function hasRootFile(dir, rf)
    for _, pattern in ipairs(rf) do
      local regex_pattern = "^" .. pattern .. "$"
      for _, entry in ipairs(vim.fn.readdir(dir)) do
        local entry_path = dir .. '/' .. entry
        if vim.fn.isdirectory(entry_path) == 0 and string.match(entry, regex_pattern) then
          return true
        end
      end
    end
    return false
  end

  -- Check if the current directory is part of a Git repository
  local function isGitDirectory(dir)
    local git_directory = dir .. '/.git'
    return vim.fn.isdirectory(git_directory) == 1
  end

  -- Check if the current directory matches any of the ignore patterns
  local function matchesIgnorePattern(dir, igp)
    for _, pattern in ipairs(igp) do
      local regex_pattern = "^" .. pattern .. "$"
      if string.match(dir, regex_pattern) then
        return true
      end
    end
    return false
  end

  -- Recursively search for subdirectories with a file in the root directory matching regex
  local function searchDirectories(dir)
    if hasRootFile(dir, root_files) and not isGitDirectory(dir) and not matchesIgnorePattern(dir, ignore_patterns) then
      table.insert(subdirectories, dir)
    end

    for _, subdirectory in ipairs(vim.fn.readdir(dir)) do
      local subdirectory_path = dir .. '/' .. subdirectory
      if vim.fn.isdirectory(subdirectory_path) == 1 then
        searchDirectories(subdirectory_path)
      end
    end
  end

  -- Perform the search within directories that match the specified regex patterns in the table
  local performSearch = function(cwd)
    for _, subdirectory in ipairs(vim.fn.readdir(cwd)) do
      local subdirectory_path = cwd .. '/' .. subdirectory
      if vim.fn.isdirectory(subdirectory_path) == 1 then
        for _, pattern in ipairs(search_dir_regex) do
          if string.match(subdirectory, pattern) then
            searchDirectories(subdirectory_path)
            break
          end
        end
      end
    end
  end

  performSearch(current_directory)

  return subdirectories
end
return findSubdirectoriesWithRootFile
