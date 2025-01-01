#!/usr/bin/env bats

setup() {
  load '../test_helper/bats-support/load'
  load '../test_helper/bats-assert/load'
  # get the containing directory of this file
  BATS_TEST_DIRNAME="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  # make executables in src/ visible to PATH
  PATH="$BATS_TEST_DIRNAME/../src:$PATH"
}

@test "treecraft exists and is executable" {
  run command -v treecraft
  assert_success
}

@test "running without arguments shows usage" {
  run treecraft
  assert_failure
  assert_output --partial "Usage:"
}

@test "running with --help shows help message" {
  run treecraft --help
  assert_success
  assert_output --partial "Usage:"
}

@test "running with --version shows version" {
  run treecraft --version
  assert_success
  assert_output --partial "TreeCraft"
}

@test "invalid option shows error" {
  run treecraft --invalid-option
  assert_failure
  assert_output --partial "Error:"
}

@test "check required commands exist" {
  run treecraft --check-deps
  assert_success
}

@test "input file not found" {
  run treecraft nonexistent.txt
  assert_failure
  assert_output --partial "Error: Input file 'nonexistent.txt' not found"
}

@test "empty input file" {
  echo "" > empty.txt
  run treecraft empty.txt
  assert_failure
  assert_output --partial "Error: Empty input file"
  rm empty.txt
}

@test "validates tree structure symbols" {
  echo "invalid" > invalid.txt
  run treecraft invalid.txt
  assert_failure
  assert_output --partial "Error: Invalid tree structure"
  rm invalid.txt
}
