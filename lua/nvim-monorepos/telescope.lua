-- shows the outupt in telescope
return function(directories_with_files)
  local finders = require "telescope.finders"
  local pickers = require "telescope.pickers"
  local sorters = require("telescope.sorters")
  local entry_marker = function(entry)
    return {
      value = entry[1],
      display = entry[1],
      ordinal = entry[1],
    }
  end

  local utils = require("nvim-monorepos.utils")
  local get_last_part_of_directory = utils.get_last_part_of_directory

  local M = {}

  for _, value in ipairs(directories_with_files) do
    local key = get_last_part_of_directory(value)
    table.insert(M, { key, value })
  end


  pickers.new({}, {
    prompt_title = "Projects",
    finder = finders.new_table {
      results = M,
    },
    sorter = sorters.get_generic_fuzzy_sorter({}),
    previewer = false,
  }):find()
end
