local get_last_part_of_directory = function(path)
  -- Split the path into parts based on the directory separator ("/" or "\")
  local parts = {}
  for part in path:gmatch("[^/\\]+") do
    table.insert(parts, part)
  end

  -- Get the last part of the path
  local last_part = parts[#parts]

  return last_part
end

--- get last two protions from a directory pattern
local function getLastTwoPortions(path, rootPatterns)
  local parts = {}
  for part in path:gmatch("[^/]+") do
    table.insert(parts, part)
  end

  for _, rootDir in ipairs(rootPatterns) do
    if string.find(path, "/" .. rootDir .. "/") then
      return table.concat({ "root/", path }, "/")
    else
      return table.concat({ parts[#parts - 1], parts[#parts] }, "/")
    end
  end
  return path
end

-- Function to get a list of subdirectories, excluding ignored ones
local function get_subdirectories(path, ignore_dirs, required_files)
  local subdirs = {}
  local output = vim.fn.systemlist('find ' .. path .. ' -type d')

  for _, dir in ipairs(output) do
    -- Check if the directory is in the ignore list
    local is_ignored = false
    for _, ignore_dir in ipairs(ignore_dirs) do
      if string.match(dir, ignore_dir) then
        is_ignored = true
        break
      end
    end

    if not is_ignored then
      -- Check if the directory contains at least one required file
      local contains_required_file = false
      for _, file in ipairs(required_files) do
        local full_path = dir .. '/' .. file
        if vim.fn.filereadable(full_path) == 1 then
          contains_required_file = true
          break
        end
      end

      if contains_required_file then
        table.insert(subdirs, dir)
      end
    end
  end

  return subdirs
end

return {
  get_last_part_of_directory = get_last_part_of_directory,
  get_subdirectories = get_subdirectories,
  getLastTwoPortions = getLastTwoPortions
}
