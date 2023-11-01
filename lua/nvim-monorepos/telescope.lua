-- shows the outupt in telescope
return function(directories_with_files)
  local finders = require "telescope.finders"
  local pickers = require "telescope.pickers"
  local conf = require("telescope.config").values
  local sorters = require("telescope.sorters")


  pickers.new({}, {
    prompt_title = "Projects",
    finder = finders.new_table {
      results = directories_with_files,
    },
    sorter = sorters.get_generic_fuzzy_sorter({}),
    previewer = false,
  }):find()
end
