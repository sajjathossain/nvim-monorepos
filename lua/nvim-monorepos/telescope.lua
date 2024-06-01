--- shows the outupt in telescope
--- @param params {directories_with_files: table, action?: "find-files" | "find-in-files"}
return function(params)
  local directories_with_files = params.directories_with_files
  local action = params.action
  action = action or "find-files"

  local status_ok_actions, actions = pcall(require, "telescope.actions")
  local status_ok_action_state, action_state = pcall(require, "telescope.actions.state")
  local status_ok_finders, finders = pcall(require, "telescope.finders")
  local status_ok_pickers, pickers = pcall(require, "telescope.pickers")
  local status_ok_builtin, builtin = pcall(require, "telescope.builtin")
  local status_ok_sorters, sorters = pcall(require, "telescope.sorters")
  local status_ok_themes, themes = pcall(require, "telescope.themes")
  local status_ok_utils, utils = pcall(require, "nvim-monorepos.utils")

  if not status_ok_actions or not status_ok_action_state or not status_ok_finders or not status_ok_pickers or not status_ok_builtin or not status_ok_sorters or not status_ok_themes or not status_ok_utils then return end

  local get_last_part_of_directory = utils.get_last_part_of_directory

  local entries = {}
  local M = {}

  for _, value in ipairs(directories_with_files) do
    local key = get_last_part_of_directory(value)
    table.insert(M, key)
    entries[key] = value
  end

  local enter = function(prompt_bufnr)
    local selected = action_state.get_selected_entry().value or ""
    local cwd = entries[selected] or ""


    -- vim.fn.chdir(cwd)
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


  pickers.new(themes.get_dropdown(), {
    prompt_title = "Projects",
    finder = finders.new_table(M),
    sorter = sorters.get_fuzzy_file(),
    selection_strategy = "reset",
    previewer = false,
    attach_mappings = attach_mappings
  }):find()
end
