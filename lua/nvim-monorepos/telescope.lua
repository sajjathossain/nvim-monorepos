local status_ok, telescope = pcall(require, "telescope")
if not status_ok then return end

telescope.setup {}
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local builtin = require("telescope.builtin")
local sorters = require("telescope.sorters")
local themes = require("telescope.themes")
local utils = require("nvim-monorepos.utils")

--- Shows the output in telescope
--- @param params {directories_with_files: table, action?: "find-files" | "find-in-files"}
return function(params)
  local directories_with_files = params.directories_with_files
  if #directories_with_files == 0 or directories_with_files == nil then return end

  local action = params.action
  action = action or "find-files"

  local get_last_part_of_directory = utils.get_last_part_of_directory

  local entries = {}
  local display_items = {}

  if #directories_with_files > 0 then
    for _, value in ipairs(directories_with_files) do
      local key = get_last_part_of_directory(value)
      table.insert(display_items, key)
      entries[key] = value
    end
  end

  local enter = function(prompt_bufnr)
    local selected = action_state.get_selected_entry().value
    local cwd = entries[selected]

    actions.close(prompt_bufnr)

    if action == "find-files" then
      builtin.find_files({ prompt_title = "Find files in " .. cwd, cwd = cwd })
    elseif action == "find-in-files" then
      builtin.live_grep({ prompt_title = "Find in files in " .. cwd, cwd = cwd })
    end
  end

  local attach_mappings = function(_, map)
    map("i", "<CR>", enter)
    map("n", "<CR>", enter)
    return true
  end

  local finder = finders.new_table({
    results = display_items,
    entry_maker = function(entry)
      return {
        value = entry,
        display = entry,
        ordinal = entry,
      }
    end
  })

  -- vim.print(display_items)

  pickers.new({}, themes.get_dropdown({
    finder = finder,
    prompt_title = "Projects",
    sorters = require("telescope.sorters").empty(),
    debounce = 100,
    sorter = sorters.get_fzy_sorter(),
    attach_mappings = attach_mappings,
  })):find()
end
