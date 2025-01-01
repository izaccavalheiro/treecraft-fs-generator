#!/bin/bash

# Enable strict mode
set -euo pipefail

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check system type and requirements
check_requirements() {
    # Detect OS
    case "$(uname -s)" in
        Darwin*)
            echo "Running on macOS"
            # Check for Intel or Apple Silicon
            if [[ $(uname -m) == "arm64" ]]; then
                echo "Apple Silicon detected"
            else
                echo "Intel processor detected"
            fi
            
            # Check for required tools
            if ! command_exists "ggrep"; then
                echo "GNU grep (ggrep) is required. Installing via Homebrew..."
                if ! command_exists "brew"; then
                    echo "Error: Homebrew is not installed. Please install Homebrew first."
                    exit 1
                fi
                brew install grep
            fi
            
            if ! command_exists "tree"; then
                echo "tree is required. Installing via Homebrew..."
                brew install tree
            fi
            
            # Set commands to use GNU versions on macOS
            GREP="ggrep"
            TREE="tree"
            ;;
        Linux*)
            echo "Running on Linux"
            GREP="grep"
            TREE="tree"
            ;;
        *)
            echo "Unsupported operating system"
            exit 1
            ;;
    esac
}

# Check if input file is provided
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

# Run requirements check
check_requirements

# Create base directory for our folder structure
base_dir="generated_structure"
mkdir -p "$base_dir"

# Function to count leading pipe characters to determine depth
count_depth() {
    local line="$1"
    local pipes=$(echo "$line" | $GREP -o "│" | wc -l)
    local spaces=$(echo "$line" | $GREP -o " " | wc -l)
    echo $((($spaces - 3) / 4))
}

# Function to extract item name from line
get_item_name() {
    local line="$1"
    echo "$line" | sed -E 's/^.*[├└]── //'
}

# Function to check if item is a directory (ends with /)
is_directory() {
    local name="$1"
    [[ "$name" == */ ]]
}

# Function to sanitize file/folder names
sanitize_name() {
    local name="$1"
    # Remove potentially problematic characters
    echo "$name" | sed -E 's/[^a-zA-Z0-9./_-]/_/g'
}

# Initialize directory stack
declare -a dir_stack=("$base_dir")
current_path="$base_dir"
prev_level=0

# Read the input file line by line
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines
    [ -z "$line" ] && continue
    
    # Skip lines without item markers
    if ! echo "$line" | $GREP -q "[├└]──"; then
        continue
    fi
    
    # Get current depth level
    current_level=$(count_depth "$line")
    
    # Get item name and sanitize it
    item=$(get_item_name "$line")
    item=$(sanitize_name "$item")
    
    # Handle directory navigation
    if [ $current_level -le $prev_level ]; then
        # Calculate how many levels to go up
        levels_up=$((prev_level - current_level + 1))
        
        # Remove directories from stack
        while [ $levels_up -gt 0 ] && [ ${#dir_stack[@]} -gt 1 ]; do
            unset 'dir_stack[${#dir_stack[@]}-1]'
            levels_up=$((levels_up - 1))
        done
        
        # Update current path
        current_path="${dir_stack[${#dir_stack[@]}-1]}"
    fi
    
    # Create new item (folder or file)
    if is_directory "$item"; then
        # Remove trailing slash for mkdir
        folder_name="${item%/}"
        new_path="$current_path/$folder_name"
        mkdir -p "$new_path"
        
        # Add to directory stack and update current path
        dir_stack+=("$new_path")
        current_path="$new_path"
    else
        # Create empty file
        touch "$current_path/$item"
    fi
    
    prev_level=$current_level
    
done < "$input_file"

echo "Structure created in '$base_dir'"

# Print the created structure using appropriate tree command
echo "Created structure:"
cd "$base_dir" && $TREE
