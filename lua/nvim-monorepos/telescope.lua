-- shows the outupt in telescope
return function(directories_with_files)
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local finders = require "telescope.finders"
  local pickers = require "telescope.pickers"
  local telescope = require("telescope")
  local builtin = require("telescope.builtin")
  local sorters = require("telescope.sorters")

  local utils = require("nvim-monorepos.utils")
  local get_last_part_of_directory = utils.get_last_part_of_directory

  local M = {}
  local entries = {}

  for _, value in ipairs(directories_with_files) do
    local key = get_last_part_of_directory(value)
    table.insert(M, key)
    table.insert(entries, { key = value })
  end

  local enter = function(prompt_bufnr)
    local selected = action_state.get_selected_entry()
    local cwd = entries[selected]
    actions.close(prompt_bufnr)
    vim.fn.chdir(cwd)
    builtin.find_files({ cwd = cwd })
  end

  local attach_mappings = function(prompt_bufnr, map)
    map("i", "<CR>", enter)
    return true
  end


  pickers.new({}, {
    prompt_title = "Projects",
    finder = finders.new_table {
      results = M,
    },
    sorter = sorters.get_generic_fuzzy_sorter({}),
    previewer = false,
    attach_mappings = attach_mappings
  }):find()
end
