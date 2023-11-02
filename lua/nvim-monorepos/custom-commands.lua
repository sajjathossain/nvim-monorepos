---------------------------------------------------------------------
----------------   Store all your custom cmds here   ----------------
----------------         Here is an example          ----------------
---------------------------------------------------------------------

-- NOTE: EXAMPLE
local methods = require("nvim-monorepos.methods")
local create_user_command = vim.api.nvim_create_user_command

local initial_directory = nil

local showAllProjectsInThisMonorepo = function()
  methods.show_projects(initial_directory)
end

create_user_command("ShowAllProjectsInThisMonorepo", showAllProjectsInThisMonorepo, {})

local init = function(dir)
  initial_directory = dir
end

return {
  init = init
}
