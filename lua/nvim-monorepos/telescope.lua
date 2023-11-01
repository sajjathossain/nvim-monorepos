-- shows the outupt in telescope
return function(directories_with_files)
  local finders = require "telescope.finders"
  local pickers = require "telescope.pickers"
  local conf = require("telescope.config").values
  local a = function(e) return { ordinal = e[1], display = e[1], value = e[1] } end

  pickers.new({}, {
    prompt_title = "Test",
    finder = finders.new_table {
      results = directories_with_files,
      entry_maker = a,
    },
    sorter = conf.generic_sorter({}),
    previewer = false,
  }):find()
end
