-- shows the outupt in telescope
return function(results)
  require("telescope.builtin").find_files({
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
  })
end