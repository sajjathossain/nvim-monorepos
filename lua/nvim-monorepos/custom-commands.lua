---------------------------------------------------------------------
----------------   Store all your custom cmds here   ----------------
----------------         Here is an example          ----------------
---------------------------------------------------------------------

-- NOTE: EXAMPLE
local M = {}
local methods = require("nvim-monorepos.methods")
local create_user_command = vim.api.nvim_create_user_command

local initial_directory = nil

local findFilesInAProject = function()
  methods.find_files(initial_directory)
end

local findInFilesInAProject = function()
  methods.find_in_files(initial_directory)
end

M.init = function(dir)
  create_user_command("FindFilesInAProject", findFilesInAProject, { nargs = 0 })
  create_user_command("FindInFilesInAProject", findInFilesInAProject, { nargs = 0 })

  initial_directory = dir
end

return M
