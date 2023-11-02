-- shows the outupt in telescope
return function(directories_with_files)
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local finders = require "telescope.finders"
  local pickers = require "telescope.pickers"
  local builtin = require("telescope.builtin")
  local sorters = require("telescope.sorters")

  local utils = require("nvim-monorepos.utils")
  local get_last_part_of_directory = utils.get_last_part_of_directory

  local entries = {}
  local M = {}

  for _, value in pairs(directories_with_files) do
    local key = get_last_part_of_directory(value)
    table.insert(M, key)
    entries[key] = value
  end

  local enter = function(prompt_bufnr)
    local selected = action_state.get_selected_entry().value
    local cwd = entries[selected]


    -- vim.fn.chdir(cwd)
    actions.close(prompt_bufnr)
    builtin.find_files({ cwd = cwd })
  end

  local attach_mappings = function(prompt_bufnr, map)
    map("i", "<CR>", enter)
    return true
  end


  pickers.new({
    sorting_strategy = 'ascending'
  }, {
    prompt_title = "Projects",
    finder = finders.new_table {
      results = M,
    },
    sorter = sorters.get_generic_fuzzy_sorter({}),
    previewer = false,
    attach_mappings = attach_mappings
  }):find()
end
