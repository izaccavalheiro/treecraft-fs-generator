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

@test "creates single file" {
    echo "/" > structure.txt
    echo "└── file.txt" >> structure.txt
    
    run treecraft structure.txt
    assert_success
    assert [ -f "generated_structure/file.txt" ]
}

@test "creates multiple files" {
    cat << EOF > structure.txt
/
├── file1.txt
└── file2.txt
EOF
    
    run treecraft structure.txt
    assert_success
    assert [ -f "generated_structure/file1.txt" ]
    assert [ -f "generated_structure/file2.txt" ]
}

@test "creates files in nested directories" {
    cat << EOF > structure.txt
/
└── folder1/
    └── file.txt
EOF
    
    run treecraft structure.txt
    assert_success
    assert [ -f "generated_structure/folder1/file.txt" ]
}

@test "creates files with various extensions" {
    cat << EOF > structure.txt
/
├── script.sh
├── doc.pdf
├── image.jpg
└── data.json
EOF
    
    run treecraft structure.txt
    assert_success
    assert [ -f "generated_structure/script.sh" ]
    assert [ -f "generated_structure/doc.pdf" ]
    assert [ -f "generated_structure/image.jpg" ]
    assert [ -f "generated_structure/data.json" ]
}

@test "handles files with spaces" {
    echo "/" > structure.txt
    echo "└── my file.txt" >> structure.txt
    
    run treecraft structure.txt
    assert_success
    assert [ -f "generated_structure/my file.txt" ]
}

@test "creates empty files" {
    echo "/" > structure.txt
    echo "└── empty.txt" >> structure.txt
    
    run treecraft structure.txt
    assert_success
    assert [ -f "generated_structure/empty.txt" ]
    assert [ ! -s "generated_structure/empty.txt" ]
}

@test "creates hidden files" {
    echo "/" > structure.txt
    echo "└── .hidden" >> structure.txt
    
    run treecraft structure.txt
    assert_success
    assert [ -f "generated_structure/.hidden" ]
}

@test "fails on invalid file characters" {
    echo "/" > structure.txt
    echo "└── invalid?.txt" >> structure.txt
    
    run treecraft structure.txt
    assert_failure
    assert_output --partial "Error: Invalid character in path"
}

@test "creates files with long names" {
    local long_name=$(printf 'a%.0s' {1..200})
    echo "/" > structure.txt
    echo "└── $long_name.txt" >> structure.txt
    
    run treecraft structure.txt
    assert_success
    assert [ -f "generated_structure/$long_name.txt" ]
}
