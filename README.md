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
[Contributing](#contributing) •
[Support](#support)

</div>

---

## 🌟 Overview

TreeCraft is a powerful command-line utility that transforms tree-style text representations into actual directory structures and files. Perfect for developers, system administrators, and DevOps professionals who need to quickly replicate directory structures across different environments.

### 🎯 Key Features

- **Cross-Platform Compatibility**: Runs seamlessly on macOS (Intel/Apple Silicon) and Linux
- **Tree-Style Input**: Uses familiar ASCII tree notation (├── and └──)
- **Smart Processing**: Creates both directories and files from your specification
- **Automated Setup**: Handles dependencies automatically via Homebrew on macOS
- **Safe Execution**: Implements robust error handling and name sanitization

## 🚀 Quick Start

### Prerequisites

- Bash shell environment
- For macOS users:
  - Homebrew (will be used to install dependencies)
- For Linux users:
  - `tree` package
  - GNU `grep`

### Installation

1. Clone the repository:
```bash
git clone https://github.com/izaccavalheiro/treecraft-fs-generator.git
cd treecraft-fs-generator
```

2. Make the script executable:
```bash
chmod +x treecraft.sh
```

3. (Optional) Add to your PATH for system-wide access:
```bash
sudo ln -s "$(pwd)/treecraft.sh" /usr/local/bin/treecraft
```

### Basic Usage

1. Create a text file (e.g., `folder-structure-sample.txt`) with your desired structure:
```
root/
├── src/
│   ├── components/
│   │   ├── Header.js
│   │   └── Footer.js
│   └── App.js
└── docs/
    ├── README.md
    └── API.md
```

2. Run TreeCraft:
```bash
./treecraft.sh folder-structure-sample.txt
```

## 📖 Documentation

### Input Format

TreeCraft accepts tree-style notation:
- Use `├──` for items that have siblings below them
- Use `└──` for the last item in a group
- Add trailing `/` to indicate directories
- Lines without trailing `/` are treated as files
- Use correct indentation with `│` for hierarchy

### Example Structures

#### Basic Web Project
```
project/
├── index.html
├── css/
│   └── style.css
├── js/
│   └── main.js
└── images/
```

#### Node.js Application
```
node-app/
├── src/
│   ├── controllers/
│   ├── models/
│   └── routes/
├── tests/
├── package.json
└── README.md
```

### Advanced Usage

#### Custom Base Directory
```bash
BASE_DIR="my-project" ./treecraft.sh folder-structure-sample.txt
```

#### Verbose Mode
```bash
VERBOSE=1 ./treecraft.sh folder-structure-sample.txt
```

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Development Setup

1. Clone your fork:
```bash
git clone https://github.com/izaccavalheiro/treecraft-fs-generator.git
cd treecraft-fs-generator
```

2. Create a new branch:
```bash
git checkout -b feature/your-feature
```

3. Make your changes and test thoroughly

4. Submit a pull request with a clear description of your changes

## ⚡ Performance

TreeCraft is designed to be lightweight and fast:
- Minimal dependencies
- Efficient file system operations
- Smart caching of directory paths
- Optimized for large directory structures

## 🔒 Security

- Input sanitization to prevent command injection
- Safe file name handling
- No execution of user-provided content
- Restricted to current directory scope

## 🐛 Troubleshooting

### Common Issues

1. **Permission Denied**
```bash
chmod +x treecraft.sh
```

2. **Missing Dependencies**
```bash
# macOS
brew install tree grep

# Linux
sudo apt-get install tree
```

3. **Invalid Input Format**
- Ensure proper indentation
- Check for missing directory slashes
- Verify tree symbols (├── and └──)

## 📜 License

Distributed under the MIT License. See `LICENSE` file for more information.

## 👥 Support

- Create an issue for bug reports
- Start a discussion for feature requests
- Check existing issues before posting

## 🌟 Acknowledgments

- Inspired by the Unix `tree` command
- Built with and for the developer community
- Special thanks to all contributors

---

<div align="center">
Made with ❤️ by Izac Cavalheiro

[![Stars](https://img.shields.io/github/stars/izaccavalheiro/treecraft-fs-generator?style=social)](https://github.com/izaccavalheiro/treecraft-fs-generator/stargazers)
[![Follow](https://img.shields.io/github/followers/izaccavalheiro?style=social)](https://github.com/izaccavalheiro)
</div>
