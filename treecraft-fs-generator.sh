#!/bin/bash

# Enable strict mode for better error handling:
# -e: exit on error
# -u: treat unset variables as errors
# -o pipefail: return value of pipeline is status of last command to exit with non-zero status
set -euo pipefail

# Check if a command exists in the system PATH
# Usage: command_exists "command_name"
# Returns: 0 if command exists, 1 if not
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS and install/configure required dependencies
# Supports: macOS (Intel/Apple Silicon) and Linux
# Installs: grep, tree via package managers
check_requirements() {
    case "$(uname -s)" in
        Darwin*)
            echo "Running on macOS"
            # Detect Apple Silicon vs Intel architecture
            if [[ $(uname -m) == "arm64" ]]; then
                echo "Apple Silicon detected"
            else
                echo "Intel processor detected"
            fi
            
            # Install GNU grep if not present
            if ! command_exists "ggrep"; then
                echo "GNU grep (ggrep) is required. Installing via Homebrew..."
                if ! command_exists "brew"; then
                    echo "Error: Homebrew is not installed."
                    exit 1
                fi
                brew install grep
            fi
            
            # Install tree utility if not present
            if ! command_exists "tree"; then
                echo "tree is required. Installing via Homebrew..."
                brew install tree
            fi
            
            # Use GNU versions of tools on macOS
            GREP="ggrep"
            TREE="tree"
            ;;
        Linux*)
            echo "Running on Linux"
            # Use standard Linux tools
            GREP="grep"
            TREE="tree"
            ;;
        *)
            echo "Unsupported operating system"
            exit 1
            ;;
    esac
}

# Validate command line arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

# Check if input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found"
    exit 1
fi

# Install and configure required tools
check_requirements

# Create base directory for the structure
base_dir="generated_structure"
mkdir -p "$base_dir"

# Calculate the depth level of a line based on indentation
# Counts both "│   " and "    " as one level
# Args: $1 - The line to analyze
# Returns: The depth level as a number
count_depth() {
    local line="$1"
    local count=0
    local i=0
    
    while [ $i -lt ${#line} ]; do
        local chunk="${line:$i:4}"
        if [[ "$chunk" == "│   " || "$chunk" == "    " ]]; then
            ((count++))
            ((i+=4))
        else
            break
        fi
    done
    
    echo "$count"
}

# Extract the item name from a line by removing tree structure characters and comments
# Args: $1 - The line containing an item
# Returns: The clean item name without comments
get_item_name() {
    local line="$1"
    # Remove tree structure characters and any comments (text after #)
    echo "$line" | sed -E 's/^.*[├└]── //' | sed -E 's/ +#.*$//'
}

# Check if an item is a directory by looking for trailing slash
# Args: $1 - Item name to check
# Returns: 0 if directory, 1 if not
is_directory() {
    local name="$1"
    [[ "$name" == */ ]]
}

# Sanitize file/folder names by removing problematic characters
# Args: $1 - Name to sanitize
# Returns: Sanitized name
sanitize_name() {
    local name="$1"
    echo "$name" | sed -E 's/[^a-zA-Z0-9./_-]/_/g'
}

# Initialize directory tracking
declare -a dir_stack=()     # Stores directory names at each level
current_path="$base_dir"    # Current working path
prev_level=0                # Previous indentation level

# Process the input file line by line
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and root marker
    [ -z "$line" ] && continue
    [[ "$line" == "/" ]] && continue
    
    # Skip lines without tree structure markers
    if ! echo "$line" | $GREP -q "[├└]──"; then
        continue
    fi
    
    # Calculate current depth and get item name (ignore comments)
    current_level=$(count_depth "$line")
    item=$(get_item_name "$line")
    item=$(sanitize_name "$item")
    
    # Handle directory level changes
    if [ $current_level -le $prev_level ]; then
        # Calculate path when going back up the tree
        levels_back=$((prev_level - current_level + 1))
        current_path="$base_dir"
        for ((i=0; i<current_level; i++)); do
            current_path="$current_path/${dir_stack[$i]}"
        done
    fi
    
    # Create directory or file based on item type
    if is_directory "$item"; then
        # Handle directory creation
        folder_name="${item%/}"
        new_path="$current_path/$folder_name"
        mkdir -p "$new_path"
        dir_stack[$current_level]="$folder_name"
        current_path="$new_path"
    else
        # Handle file creation (ignore comments)
        touch "$current_path/$item"
    fi
    
    prev_level=$current_level
    
done < "$input_file"

# Display results
echo "Structure created in '$base_dir'"
cd "$base_dir" && $TREE
