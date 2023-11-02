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

### Default config

- patterns

```lua
{
    files = { "project.json", "package.json" }, -- Replace with your file patterns
    ignore = { ".git", "node_modules", "build" },
}
```

**Note:** Pass a table of files, or ignore to update the pattern. `files` are the ones that the system will search for and list only the directories that has the file in its root. And the `ignore` patterns will be ignored from listing.
