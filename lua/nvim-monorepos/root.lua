-- Function to find root directory based on pattern
local setRootDirectory = function()
  local function findRootDirectory(root_patterns)
    local current_directory = vim.fn.getcwd()

    -- Define a helper function to check if the current directory matches any root patterns
    local function isRootDirectory(directory, rpatterns)
      for _, pattern in ipairs(rpatterns) do
        if vim.fn.isdirectory(directory .. '/' .. pattern) == 1 then
          return true
        end
      end
      return false
    end

    -- Search for the root directory starting from the current directory
    while current_directory ~= "/" do
      if isRootDirectory(current_directory, root_patterns) then
        return current_directory
      end
      current_directory = vim.fn.fnamemodify(current_directory, ":h")
    end

    return nil
  end

  -- Define the root patterns (e.g., .git, .svn)
  local root_patterns = { ".git", ".svn" }

  -- Find the root directory based on the patterns
  local root_directory = findRootDirectory(root_patterns)

  if root_directory then
    -- Change the working directory to the root directory
    vim.fn.chdir(root_directory)
    -- print("Changed working directory to: " .. root_directory)
  else
    print("Root directory not found based on the specified patterns.")
  end
end

return setRootDirectory
