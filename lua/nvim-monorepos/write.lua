-- function to write the outputs
return function(output_file, root_directories_with_files)
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
