-- shows the outupt in telescope
return function(directories_with_files)
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local finders = require "telescope.finders"
  local pickers = require "telescope.pickers"
  local sorters = require("telescope.sorters")
  local write = require("nvim-monorepos.write").writeOutput

  local utils = require("nvim-monorepos.utils")
  local get_last_part_of_directory = utils.get_last_part_of_directory

  local M = {}

  for _, value in ipairs(directories_with_files) do
    local key = get_last_part_of_directory(value)
    -- table.insert(M, { key, value })
    table.insert(M, { key, value })
  end

  local enter = function(prompt_bufnr)
    local selected = action_state.get_selected_entry()
    write(table.concat(selected, ""))
    actions.close(prompt_bufnr)
  end

  local attach_mappings = function(prompt_bufnr, map)
    map("i", "<CR>", enter)
    return true
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
        return maker
      end
    },
    sorter = sorters.get_generic_fuzzy_sorter({}),
    previewer = false,
    attach_mappings = attach_mappings
  }):find()
end
