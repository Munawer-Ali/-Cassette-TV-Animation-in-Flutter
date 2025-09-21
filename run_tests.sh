#!/bin/bash

# Cassette Animation Test Runner
# This script runs all tests for the cassette animation project

echo "🎵 Running Cassette Animation Tests..."
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to run tests with colored output
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -e "${BLUE}Running $test_name...${NC}"
    
    if eval "$test_command"; then
        echo -e "${GREEN}✅ $test_name passed${NC}"
        return 0
    else
        echo -e "${RED}❌ $test_name failed${NC}"
        return 1
    fi
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Please run this script from the project root directory${NC}"
    exit 1
fi

# Get dependencies
echo -e "${YELLOW}📦 Getting dependencies...${NC}"
flutter pub get

# Run different types of tests
echo ""
echo -e "${YELLOW}🧪 Running Unit Tests...${NC}"
echo "=========================="

# Unit tests for services
run_test "USDZ Method Channel Tests" "flutter test test/services/usdz_method_channel_test.dart"
run_test "Animation Service Tests" "flutter test test/services/cassette_animation_service_test.dart"

echo ""
echo -e "${YELLOW}🎨 Running Widget Tests...${NC}"
echo "=========================="

# Widget tests
run_test "Widget Tests" "flutter test test/widget_test.dart"

echo ""
echo -e "${YELLOW}🔗 Running Integration Tests...${NC}"
echo "=============================="

# Integration tests
run_test "Integration Tests" "flutter test test/integration_test.dart"

echo ""
echo -e "${YELLOW}📊 Running All Tests...${NC}"
echo "======================"

# Run all tests
run_test "All Tests" "flutter test"

# Summary
echo ""
echo "======================================"
echo -e "${GREEN}🎉 Test run completed!${NC}"
echo "======================================"

# Optional: Generate test coverage report
if command -v genhtml &> /dev/null; then
    echo ""
    echo -e "${YELLOW}📈 Generating coverage report...${NC}"
    flutter test --coverage
    if [ -f "coverage/lcov.info" ]; then
        genhtml coverage/lcov.info -o coverage/html
        echo -e "${GREEN}✅ Coverage report generated in coverage/html/index.html${NC}"
    fi
fi

echo ""
echo -e "${BLUE}💡 Tips:${NC}"
echo "  - Run specific tests: flutter test test/services/usdz_method_channel_test.dart"
echo "  - Run with coverage: flutter test --coverage"
echo "  - Run in verbose mode: flutter test --verbose"
echo "  - Run tests in watch mode: flutter test --watch"
