---@class MonorepoConfig
---@field files string[] File patterns to search for in project roots
---@field ignore string[] Directory patterns to ignore during search
---@field root string[] Root directory patterns (currently unused but reserved for future use)

local M = {}

---@type MonorepoConfig
M.defaults = {
  files = { "project.json", "package.json" },
  ignore = { ".git", "node_modules", "build" },
  root = {}
}

---Merge user options with defaults
---@param user_opts MonorepoConfig?
---@return MonorepoConfig
M.setup = function(user_opts)
  user_opts = user_opts or {}
  
  local config = vim.tbl_deep_extend("force", M.defaults, user_opts)
  
  -- Validate configuration
  if type(config.files) ~= "table" or #config.files == 0 then
    vim.notify("nvim-monorepos: 'files' must be a non-empty table", vim.log.levels.WARN)
    config.files = M.defaults.files
  end
  
  if type(config.ignore) ~= "table" then
    vim.notify("nvim-monorepos: 'ignore' must be a table", vim.log.levels.WARN)
    config.ignore = M.defaults.ignore
  end
  
  return config
end

return M
