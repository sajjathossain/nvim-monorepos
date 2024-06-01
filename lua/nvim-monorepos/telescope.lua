--- Shows the output in telescope
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

  pickers.new(themes.get_dropdown({
    prompt_title = "Projects",
    prompt_prefix = "🔍 ",
    results_title = "Select a Project",
    preview_title = "Project Preview",
    layout_config = {
      horizontal = {
        preview_width = 0.5,
      },
    },
    initial_mode = "insert",
    default_text = nil,
    border = true,
    winblend = 10,
    attach_mappings = attach_mappings,
  }), {
    finder = finders.new_table {
      results = display_items,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = entry
        }
      end
    },
    sorter = sorters.get_fuzzy_file(),
    previewer = false,
  }):find()
end
