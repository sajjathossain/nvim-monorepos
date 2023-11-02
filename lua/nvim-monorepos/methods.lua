local telescope = require("nvim-monorepos.telescope")

local show_projects = function(directories)
  telescope(directories)
end

return {
  show_projects = show_projects
}
