-- shows the outupt in telescope
return function(directories_with_files)
  local finders = require "telescope.finders"
  local pickers = require "telescope.pickers"
  local sorters = require("telescope.sorters")
  local write = require("nvim-monorepos.write")
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
    table.insert(M, key)
  end


  pickers.new({}, {
    prompt_title = "Projects",
    finder = finders.new_table {
      results = M,
      entry_maker = function(entry)
        local maker = {
          value = entry,
          display = entry[1],
          ordinal = entry[1],
        }

        write("output.txt", { entry })
        return maker
      end
    },
    sorter = sorters.get_generic_fuzzy_sorter({}),
    previewer = false,
  }):find()
end
