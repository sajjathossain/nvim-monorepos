local M = {}
-- function to write the outputs
M.write = function(output_file, root_directories_with_files)
  -- Open the output file for writing
  local file = io.open(output_file, "w")

  if file then
    for _, dir in ipairs(root_directories_with_files) do
      local absolute_path = vim.fn.fnamemodify(dir, ":p") -- Get the absolute path of the root directory
      file:write(absolute_path .. "\n")                   -- Write each absolute path to a new line
    end
    file:close()                                          -- Close the file
    print("Results have been written to " .. output_file)
  else
    print("Failed to open the output file for writing.")
  end
end

-- function to write output the outputs
M.writeOutput = function(output_file, value)
  -- Open the output file for writing
  local file = io.open(output_file, "w")

  if file then
    if (type(value) == "table") then
      file:write(table.concat(value, "")) -- Write each absolute path to a new line
    elseif (type(value) == "string") then
      file:write(table.concat(value, "")) -- Write each absolute path to a new line
    end

    file:close() -- Close the file
    print("Results have been written to " .. output_file)
  else
    print("Failed to open the output file for writing.")
  end
end

return M
