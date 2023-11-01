-- shows the outupt in telescope
return function(directories_with_files)
  local finders = require "telescope.finders"
  local pickers = require "telescope.pickers"
  local conf = require("telescope.config").values

  pickers.new({}, {
    prompt_title = "Projects",
    finder = finders.new_table {
      results = directories_with_files,
      entry_maker = function(x) return x end,
    },
    sorter = conf.generic_sorter({}),
    previewer = true,
  }):find()
end
