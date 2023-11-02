<h1>Nvim Monorepos</h1>

this is a simple project picker. it finds all the projects matching a specific pattern of files in your sub directories and lists them using **telescope.nvim**. when select any of the project, it will show all the files of that project. this makes it easier to find files when you're working with a mono repo

### Install
- lazy
```lua
{
  "sajjathossain/nvim-monorepos",
  dependencies = {
    "nvim-telescope/telescope.nvim"
  },
  cmd = {
    "ShowAllProjectsInThisMonorepo"
  },
  config = true
}
```
or
```lua
{
  "sajjathossain/nvim-monorepos",
  dependencies = {
    "nvim-telescope/telescope.nvim"
  },
  cmd = {
    "ShowAllProjectsInThisMonorepo"
  },
  config = function()
    require("nvim-monorepos").setup()
  end
}
```

### available methods
- show projects
```lua
require("nvim-monorepos").show_projects()
```

### available commands
- show projects
```lua
ShowProjectsInThisMonorepo
```
