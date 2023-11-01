-- shows the outupt in telescope
return function(directories_with_files)
  local finders = require "telescope.finders"
  local pickers = require "telescope.pickers"
  local conf = require("telescope.config").values
  local data = { { 'this' }, { 'is' }, { 'a' }, { 'test' } }
  local a = function(e) return { ordinal = e[1], display = e[1], value = e[1] } end

  pickers.new({}, {
    prompt_title = "Projects",
    finder = finders.new_table {
      results = data,
      entry_maker = a,
    },
    sorter = conf.generic_sorter({}),
    previewer = true,
  }):find()
end
