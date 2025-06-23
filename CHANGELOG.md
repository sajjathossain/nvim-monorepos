# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased] - Code Refactor & Improvements

### Added
- Comprehensive documentation with type annotations
- Better error handling and user feedback
- Modular architecture with clear separation of concerns
- Configuration validation
- Test script for basic functionality verification

### Changed
- **BREAKING**: Restructured entire codebase for better maintainability
- Improved naming conventions (consistent snake_case)
- Enhanced error messages and user notifications
- Better telescope integration with proper themes
- More robust configuration handling

### Removed
- Unused files: `root.lua`, `write.lua` (functionality not used)
- Redundant code and duplicate logic
- Inconsistent error handling patterns

### Fixed
- Proper error handling for missing telescope.nvim dependency
- Configuration edge cases and validation
- Memory leaks from unused variables

### Technical Improvements
- **config.lua**: Centralized configuration management with validation
- **scanner.lua**: Directory scanning and filtering logic
- **picker.lua**: Telescope integration and UI handling  
- **commands.lua**: User command definitions
- **init.lua**: Main plugin interface and setup

### File Structure
```
lua/nvim-monorepos/
├── init.lua          # Main plugin interface
├── config.lua        # Configuration management
├── scanner.lua       # Directory scanning utilities
├── picker.lua        # Telescope picker implementation
└── commands.lua      # User command definitions
```

### Migration Guide
The plugin API remains the same, so no changes are needed for existing users:
- `require("nvim-monorepos").setup(options)` - unchanged
- `require("nvim-monorepos").find_files()` - unchanged  
- `require("nvim-monorepos").find_in_files()` - unchanged
- Commands `:FindFilesInAProject` and `:FindInFilesInAProject` - unchanged
