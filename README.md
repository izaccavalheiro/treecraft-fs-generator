# TreeCraft

<div align="center">

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![Bash](https://img.shields.io/badge/Language-Bash-blue.svg)](https://www.gnu.org/software/bash/)
[![macOS](https://img.shields.io/badge/Platform-macOS-lightgrey.svg)](https://www.apple.com/macos)
[![Linux](https://img.shields.io/badge/Platform-Linux-orange.svg)](https://www.linux.org/)

Turn ASCII tree diagrams into real file system structures with a single command.

[Installation](#installation) •
[Usage](#usage) •
[Features](#features) •
[Documentation](#documentation) •
[Contributing](#contributing)

</div>

## 🎯 What's New

### v2.0.0 - Major Update
- Complete rewrite of directory nesting algorithm
- Support for both "│   " and "    " indentation patterns
- Improved cross-platform compatibility
- Enhanced error handling and input validation
- Automatic dependency management

## 🚀 Quick Start

### Prerequisites
- Bash shell environment
- For macOS:
  - Homebrew (auto-installs dependencies)
- For Linux:
  - `tree` package
  - GNU `grep`

### Installation
```bash
git clone https://github.com/izaccavalheiro/treecraft-fs-generator.git
cd treecraft-fs-generator
chmod +x treecraft-fs-generator.sh
```

Optional: Add to PATH
```bash
sudo ln -s "$(pwd)/treecraft-fs-generator.sh" /usr/local/bin/treecraft
```

## 📋 Usage

1. Create your structure file (e.g., `folder-structure-sample.txt`):
```
/
└── root/
    └── test/
        ├── unit/
        │   ├── 01_basic_operations.bats
        │   └── 02_directory_creation.bats
        └── integration/
            └── 01_full_structure.bats
```

2. Run TreeCraft:
```bash
./treecraft-fs-generator.sh folder-structure-sample.txt
```

## ✨ Features

### Input Format Support
- Standard tree format (`├──`, `└──`)
- Mixed indentation patterns
- Vertical bar with spaces (`│   `)
- Four space indentation (`    `)

### Cross-Platform Support
- macOS (Intel & Apple Silicon)
- Linux distributions
- Automatic dependency handling
- Platform-specific optimizations

### Advanced File System Operations
- Deep nested structures
- Mixed files and directories
- Special character handling
- Permission management
- Path length validation

## 🛠 Development Setup

### Running Tests
```bash
# Install BATS
npm install -g bats
git clone https://github.com/bats-core/bats-support test/test_helper/bats-support
git clone https://github.com/bats-core/bats-assert test/test_helper/bats-assert

# Run test suites
bats test/unit/*.bats
```

### Test Categories
- Unit tests
  - Basic operations
  - Directory creation
  - File creation
  - Error handling
- Integration tests
  - Full structures
  - Cross-platform
  - Dependencies
- Edge case tests
  - Special characters
  - Deep nesting
  - Permissions

## 📖 Documentation

### Indentation Rules
- Each level uses 4 characters
- Supports two patterns:
  1. Vertical bar + spaces: `│   `
  2. Four spaces: `    `

### Directory Markers
- Directories end with forward slash: `folder/`
- Files have no trailing slash: `file.txt`

### Tree Symbols
- `├──` for items with siblings below
- `└──` for last items in their groups
- `│   ` for vertical lines in the tree

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'feat: add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 🐛 Known Limitations

- Maximum path length dependent on OS
- File content creation not supported
- No symbolic link support
- No file permission configuration

## 📜 License

Distributed under the MIT License. See `LICENSE` file for more information.

---

<div align="center">
Made with ❤️ by [Izac Cavalheiro]

[![Stars](https://img.shields.io/github/stars/izaccavalheiro/treecraft-fs-generator?style=social)](https://github.com/izaccavalheiro/treecraft-fs-generator/stargazers)
</div>