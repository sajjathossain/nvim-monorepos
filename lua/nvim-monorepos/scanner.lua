---Directory scanning utilities for finding monorepo projects
local M = {}

---Check if a directory should be ignored based on ignore patterns
---@param path string Directory path to check
---@param ignore_patterns string[] Patterns to ignore
---@return boolean should_ignore True if directory should be ignored
local function should_ignore_directory(path, ignore_patterns)
  for _, pattern in ipairs(ignore_patterns) do
    if string.find(path, pattern, 1, true) then
      return true
    end
  end
  return false
end

---Check if a directory contains any of the specified file patterns
---@param directory string Directory path to check
---@param file_patterns string[] File patterns to look for
---@return boolean has_files True if directory contains matching files
local function directory_has_files(directory, file_patterns)
  local files = vim.fn.readdir(directory)
  
  for _, pattern in ipairs(file_patterns) do
    for _, file in ipairs(files) do
      if file == pattern then
        return true
      end
    end
  end
  
  return false
end

---Recursively find all subdirectories, excluding ignored patterns
---@param root_directory string Starting directory for search
---@param ignore_patterns string[] Directory patterns to ignore
---@return string[] subdirectories List of found subdirectories
M.find_subdirectories = function(root_directory, ignore_patterns)
  local subdirectories = {}

  local function scan_recursive(directory)
    if should_ignore_directory(directory, ignore_patterns) then
      return
    end
    
    local items = vim.fn.readdir(directory)
    
    for _, item in ipairs(items) do
      local path = directory .. '/' .. item
      local is_directory = vim.fn.isdirectory(path)
      
      if is_directory == 1 and item ~= '.' and item ~= '..' then
        table.insert(subdirectories, path)
        scan_recursive(path)
      end
    end
  end
  
  scan_recursive(root_directory)
  return subdirectories
end

---Filter directories to only include those containing specified file patterns
---@param directories string[] List of directories to filter
---@param file_patterns string[] File patterns that must be present
---@return string[] filtered_directories Directories containing the specified files
M.filter_directories_with_files = function(directories, file_patterns)
  local filtered_directories = {}
  
  for _, directory in ipairs(directories) do
    if directory_has_files(directory, file_patterns) then
      table.insert(filtered_directories, directory)
    end
  end
  
  return filtered_directories
end

---Get the last part of a directory path (basename)
---@param directory_path string Full directory path
---@return string basename Last part of the directory path
M.get_directory_basename = function(directory_path)
  return vim.fn.fnamemodify(directory_path, ':t') or ""
end

---Create a display name showing parent context for better identification
---@param directory_path string Full directory path
---@param root_directory string Root directory being scanned
---@return string display_name Formatted display name with parent context
M.create_display_name = function(directory_path, root_directory)
  local relative_path = vim.fn.fnamemodify(directory_path, ':~:.')
  
  -- Remove leading ./ if present
  if vim.startswith(relative_path, './') then
    relative_path = string.sub(relative_path, 3)
  end
  
  -- If the path is too long, show parent/current format
  local parts = vim.split(relative_path, '/')
  if #parts > 3 then
    -- Show first part ... parent/current for very deep paths
    local first = parts[1]
    local parent = parts[#parts - 1]
    local current = parts[#parts]
    return first .. "/.../" .. parent .. "/" .. current
  elseif #parts > 2 then
    -- Show parent/current for moderately deep paths
    local parent = parts[#parts - 1]
    local current = parts[#parts]
    return parent .. "/" .. current
  elseif #parts == 2 then
    -- Show parent/current for two-level paths
    return parts[1] .. "/" .. parts[2]
  else
    -- Show just the directory name for single level
    return relative_path
  end
end

---Get project files that exist in a directory
---@param directory string Directory path to check
---@param file_patterns string[] File patterns to look for
---@return string[] found_files List of project files found
M.get_project_files = function(directory, file_patterns)
  local found_files = {}
  local files = vim.fn.readdir(directory)
  
  for _, pattern in ipairs(file_patterns) do
    for _, file in ipairs(files) do
      if file == pattern then
        table.insert(found_files, file)
      end
    end
  end
  
  return found_files
end

---Find all project directories based on configuration
---@param root_directory string Starting directory for search
---@param config table Configuration with files and ignore patterns
---@return string[] project_directories List of directories containing project files
M.find_project_directories = function(root_directory, config)
  local all_directories = M.find_subdirectories(root_directory, config.ignore)
  return M.filter_directories_with_files(all_directories, config.files)
end

return M
