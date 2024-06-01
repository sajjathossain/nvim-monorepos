local M = {}
local status_ok_telescope, telescope = pcall(require, "nvim-monorepos.telescope")

if not status_ok_telescope then return end

M.find_files = function(directories)
  telescope({ directories_with_files = directories, action = "find-files" })
end

M.find_in_files = function(directories)
  telescope({ directories_with_files = directories, action = "find-in-files" })
end

return M
