-- shows the outupt in telescope
return function(directories_with_files)
  local finders = require "telescope.finders"
  local pickers = require "telescope.pickers"
  local conf = require("telescope.config").values
  local sorters = require("telescope.sorters")

  local data = {
    { ordinal = 'a', display = 'a', value = 'a' },
    { ordinal = 'b', display = 'b', value = 'b' },
  }

  pickers.new({}, {
    prompt_title = "Projects",
    finder = finders.new_table {
      results = data,
    },
    sorter = sorters.get_generic_fuzzy_sorter({}),
    previewer = false,
  }):find()
end
