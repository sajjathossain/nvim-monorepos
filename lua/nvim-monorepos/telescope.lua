-- shows the outupt in telescope
return function(directories_with_files)
  -- Convert the results to a format that Telescope.nvim can handle using finders.new_table
  local results = require("telescope.finders").new_table {
    results = directories_with_files,
  }

  -- Load Telescope.nvim and use the select function to display the results using the selector
  require("telescope.builtin").find_files {
    prompt_title = "Directories with Matching Files",
    entry_maker = function(entry)
      return {
        value = entry,
        ordinal = entry,
        display = entry,
      }
    end,
    sorter = require("telescope.sorters").get_fzy_sorter(),
    attach_mappings = function(_, map)
      map("i", "<CR>", function(prompt_bufnr)
        local selection = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(prompt_bufnr)
        -- Handle the selected directory (e.g., navigate to it)
        -- You can customize this part as needed
        vim.cmd("cd " .. selection.value)
      end)
      return true
    end,
    results = results,
  }
end
