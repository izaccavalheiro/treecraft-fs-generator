#!/usr/bin/env bats

setup() {
    load '../test_helper/bats-support/load'
    load '../test_helper/bats-assert/load'
    BATS_TEST_DIRNAME="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$BATS_TEST_DIRNAME/../src:$PATH"
    TEST_TEMP_DIR="$(mktemp -d)"
    cd "$TEST_TEMP_DIR"
}

teardown() {
    rm -rf "$TEST_TEMP_DIR"
}

@test "handles malformed tree structure" {
    echo "/" > structure.txt
    echo "--- malformed line" >> structure.txt
    
    run treecraft structure.txt
    assert_failure
    assert_output --partial "Error: Invalid tree structure"
}

@test "handles invalid depth progression" {
    cat << EOF > structure.txt
/
└── folder1/
      └── invalid-indent/
EOF
    
    run treecraft structure.txt
    assert_failure
    assert_output --partial "Error: Invalid indentation"
}

@test "handles missing root directory" {
    echo "└── folder1/" > structure.txt
    
    run treecraft structure.txt
    assert_failure
    assert_output --partial "Error: Missing root directory"
}

@test "handles permission denied" {
    echo "/" > structure.txt
    echo "└── folder1/" >> structure.txt
    
    mkdir -p generated_structure
    chmod 000 generated_structure
    
    run treecraft structure.txt
    assert_failure
    assert_output --partial "Error: Permission denied"
    
    chmod 755 generated_structure
}

@test "handles disk full scenario" {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        skip "Test not supported on macOS"
    fi
    
    # Create a small ramdisk and mount it
    mkdir -p mnt
    mount -t tmpfs -o size=1M tmpfs mnt
    cd mnt
    
    # Try to create a structure larger than available space
    echo "/" > structure.txt
    for i in {1..1000}; do
        echo "├── file$i.txt" >> structure.txt
    done
    
    run treecraft structure.txt
    assert_failure
    assert_output --partial "Error: No space left on device"
    
    cd ..
    umount mnt
}

@test "handles invalid symlinks" {
    cat << EOF > structure.txt
/
└── invalid-link -> /nonexistent
EOF
    
    run treecraft structure.txt
    assert_failure
    assert_output --partial "Error: Invalid symlink target"
}

@test "handles duplicate names" {
    cat << EOF > structure.txt
/
├── folder1/
└── folder1/
EOF
    
    run treecraft structure.txt
    assert_failure
    assert_output --partial "Error: Duplicate name"
}

@test "handles path too long" {
    # Create a structure with extremely long path
    echo "/" > structure.txt
    current="└── "
    for i in {1..100}; do
        current="${current}very_long_folder_name_that_keeps_going/"
        echo "$current" >> structure.txt
    done
    
    run treecraft structure.txt
    assert_failure
    assert_output --partial "Error: Path too long"
}

@test "handles invalid characters in paths" {
    cat << EOF > structure.txt
/
├── folder:1/
├── file*.txt
└── <invalid>/
EOF
    
    run treecraft structure.txt
    assert_failure
    assert_output --partial "Error: Invalid character in path"
}

@test "handles mixed line endings" {
    # Create file with mixed line endings
    printf "/\r\n├── folder1/\n└── folder2/\r\n" > structure.txt
    
    run treecraft structure.txt
    assert_success
    assert [ -d "generated_structure/folder1" ]
    assert [ -d "generated_structure/folder2" ]
}
