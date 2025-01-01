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

@test "creates single directory" {
    echo "/" > structure.txt
    echo "└── folder1/" >> structure.txt
    
    run treecraft structure.txt
    assert_success
    assert [ -d "generated_structure/folder1" ]
}

@test "creates multiple directories" {
    cat << EOF > structure.txt
/
├── folder1/
└── folder2/
EOF
    
    run treecraft structure.txt
    assert_success
    assert [ -d "generated_structure/folder1" ]
    assert [ -d "generated_structure/folder2" ]
}

@test "creates nested directories" {
    cat << EOF > structure.txt
/
└── folder1/
    └── subfolder1/
        └── subsubfolder1/
EOF
    
    run treecraft structure.txt
    assert_success
    assert [ -d "generated_structure/folder1/subfolder1/subsubfolder1" ]
}

@test "creates parallel nested directories" {
    cat << EOF > structure.txt
/
├── folder1/
│   └── subfolder1/
└── folder2/
    └── subfolder2/
EOF
    
    run treecraft structure.txt
    assert_success
    assert [ -d "generated_structure/folder1/subfolder1" ]
    assert [ -d "generated_structure/folder2/subfolder2" ]
}

@test "handles directory names with spaces" {
    echo "/" > structure.txt
    echo "└── my folder/" >> structure.txt
    
    run treecraft structure.txt
    assert_success
    assert [ -d "generated_structure/my folder" ]
}

@test "creates complex directory structure" {
    cat << EOF > structure.txt
/
├── src/
│   ├── components/
│   │   ├── header/
│   │   └── footer/
│   └── utils/
└── tests/
    ├── unit/
    └── integration/
EOF
    
    run treecraft structure.txt
    assert_success
    assert [ -d "generated_structure/src/components/header" ]
    assert [ -d "generated_structure/src/components/footer" ]
    assert [ -d "generated_structure/src/utils" ]
    assert [ -d "generated_structure/tests/unit" ]
    assert [ -d "generated_structure/tests/integration" ]
}

@test "fails on invalid directory characters" {
    echo "/" > structure.txt
    echo "└── invalid*/folder/" >> structure.txt
    
    run treecraft structure.txt
    assert_failure
    assert_output --partial "Error: Invalid character in path"
}

@test "handles maximum path depth" {
    # Create a deeply nested structure
    echo "/" > structure.txt
    current="└── level1/"
    for i in {2..50}; do
        echo "$current" >> structure.txt
        current="    └── level$i/"
    done
    
    run treecraft structure.txt
    assert_success
    # Test the deepest directory exists
    assert [ -d "generated_structure/level1/level2/level3/level4/level5" ]
}
