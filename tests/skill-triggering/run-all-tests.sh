#!/bin/bash
# Run all skill triggering tests
# This tests both skill creation AND package usage scenarios

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

FAILED_TESTS=()
PASSED_TESTS=()

echo "================================"
echo "Running R Package Skills Tests"
echo "================================"
echo ""

# Function to run a single test
run_test() {
    local skill_name="$1"
    local prompt_file="$2"
    local test_name=$(basename "$prompt_file" .txt)

    echo "---"
    echo "TEST: $test_name ($skill_name)"
    echo "---"

    if ./run-test.sh "$skill_name" "$prompt_file"; then
        PASSED_TESTS+=("$test_name")
    else
        FAILED_TESTS+=("$test_name")
    fi

    echo ""
}

# Test 1: r-package-skill creation trigger
run_test "r-package-skill" "prompts/creation/create-ipumsr-skill.txt"

# Test 2: Package skill trigger on library() call
run_test "r-mapgl" "prompts/usage/mapgl-library-call.txt"

# Test 3: Package skill trigger on package::function() call
run_test "r-collapse" "prompts/usage/collapse-function-call.txt"

# Test 4: Trigger on pacman::p_load() with multiple packages
run_test "r-mapgl" "prompts/usage/pacman-p-load-multi.txt"

# Test 5: Trigger on .pmtiles file reference (no package name)
run_test "r-freestiler" "prompts/usage/pmtiles-file-only.txt"

# Test 6: Trigger on namespace::function() call (ellmer)
run_test "r-ellmer" "prompts/usage/namespace-ellmer.txt"

# Test 7: Trigger on library() + file extension (.docx)
run_test "r-flextable" "prompts/usage/library-flextable-docx.txt"

echo "================================"
echo "Test Summary"
echo "================================"
echo "PASSED: ${#PASSED_TESTS[@]}"
echo "FAILED: ${#FAILED_TESTS[@]}"
echo ""

if [ ${#FAILED_TESTS[@]} -gt 0 ]; then
    echo "Failed tests:"
    for test in "${FAILED_TESTS[@]}"; do
        echo "  ❌ $test"
    done
    exit 1
else
    echo "✅ All tests passed!"
    exit 0
fi
