# Nvim Monorepos

A simple and efficient file picker for monorepo projects. This plugin finds all directories containing specific file patterns (like `package.json` or `project.json`) and provides a telescope.nvim interface to quickly navigate and search within those projects.

## Features

- 🔍 **Project Discovery**: Automatically finds project directories based on configurable file patterns
- 📁 **File Navigation**: Quick file finding within selected projects using telescope.nvim
- 🔎 **Text Search**: Live grep functionality within project directories
- ⚙️ **Configurable**: Customizable file patterns and ignore rules
- 🚀 **Performance**: Efficient directory scanning with ignore patterns

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "sajjathossain/nvim-monorepos",
  dependencies = {
    "nvim-telescope/telescope.nvim"
  },
  cmd = {
    "FindFilesInAProject",
    "FindInFilesInAProject"
  },
  config = true
}
```

### With custom configuration

```lua
{
  "sajjathossain/nvim-monorepos",
  dependencies = {
    "nvim-telescope/telescope.nvim"
  },
  cmd = {
    "FindFilesInAProject",
    "FindInFilesInAProject"
  },
  config = function()
    require("nvim-monorepos").setup({
      files = { "package.json", "Cargo.toml", "go.mod" },
      ignore = { ".git", "node_modules", "target", "build" }
    })
  end
}
```

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `:FindFilesInAProject` | Open project picker, then find files in selected project |
| `:FindInFilesInAProject` | Open project picker, then search text in selected project |

### Lua API

```lua
local monorepos = require("nvim-monorepos")

-- Find files in a project
monorepos.find_files()

-- Search text in project files
monorepos.find_in_files()
```

## Configuration

### Default Configuration

```lua
{
  files = { "project.json", "package.json" },
  ignore = { ".git", "node_modules", "build" }
}
```

### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `files` | `string[]` | `{"project.json", "package.json"}` | File patterns to identify project root directories |
| `ignore` | `string[]` | `{".git", "node_modules", "build"}` | Directory patterns to ignore during scanning |

### Example Configurations

#### For JavaScript/TypeScript projects
```lua
require("nvim-monorepos").setup({
  files = { "package.json", "tsconfig.json" },
  ignore = { ".git", "node_modules", "dist", ".next" }
})
```

#### For Rust projects
```lua
require("nvim-monorepos").setup({
  files = { "Cargo.toml" },
  ignore = { ".git", "target", "node_modules" }
})
```

#### For Go projects
```lua
require("nvim-monorepos").setup({
  files = { "go.mod" },
  ignore = { ".git", "vendor", "bin" }
})
```

#### For mixed language monorepos
```lua
require("nvim-monorepos").setup({
  files = { "package.json", "Cargo.toml", "go.mod", "pom.xml" },
  ignore = { ".git", "node_modules", "target", "vendor", "build" }
})
```

## How It Works

1. **Scanning**: The plugin recursively scans your current working directory
2. **Filtering**: Directories are filtered based on ignore patterns
3. **Project Detection**: Directories containing any of the specified file patterns are identified as projects
4. **Selection**: Telescope picker shows all found projects for selection
5. **Action**: Selected project opens telescope's file finder or live grep

## Requirements

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- Neovim >= 0.7.0

## License

MIT License - see [LICENSE](LICENSE) file for details.
