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

return {
  get_last_part_of_directory = get_last_part_of_directory
}
