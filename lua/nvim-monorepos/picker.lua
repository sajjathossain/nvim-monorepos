---Telescope picker for project selection and file operations
local M = {}

local scanner = require("nvim-monorepos.scanner")

---@type table|nil
local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
  vim.notify("nvim-monorepos: telescope.nvim is required but not found", vim.log.levels.ERROR)
  return M
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local builtin = require("telescope.builtin")
local sorters = require("telescope.sorters")
local themes = require("telescope.themes")

---Create telescope picker for project selection
---@param project_directories string[] List of project directories
---@param action_type "find_files"|"find_in_files" Type of action to perform
M.show_project_picker = function(project_directories, action_type)
  if not project_directories or #project_directories == 0 then
    vim.notify("nvim-monorepos: No project directories found", vim.log.levels.WARN)
    return
  end
  
  -- Create display entries mapping display name to full path
  local entries = {}
  local display_items = {}
  
  for _, directory in ipairs(project_directories) do
    local basename = scanner.get_directory_basename(directory)
    table.insert(display_items, basename)
    entries[basename] = directory
  end
  
  local function on_select(prompt_bufnr)
    local selected = action_state.get_selected_entry().value
    local selected_directory = entries[selected]
    
    actions.close(prompt_bufnr)
    
    if action_type == "find_files" then
      builtin.find_files({
        prompt_title = "Find files in " .. selected,
        cwd = selected_directory
      })
    elseif action_type == "find_in_files" then
      builtin.live_grep({
        prompt_title = "Find in files in " .. selected,
        cwd = selected_directory
      })
    end
  end
  
  local function attach_mappings(_, map)
    map("i", "<CR>", on_select)
    map("n", "<CR>", on_select)
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
  
  pickers.new({}, themes.get_dropdown({
    finder = finder,
    prompt_title = "Select Project",
    sorter = sorters.get_fzy_sorter(),
    attach_mappings = attach_mappings,
  })):find()
end

return M
