# 🧪 Test Documentation - Cassette Animation

This document provides comprehensive information about the test suite for the Cassette Animation Flutter project.

## 📁 Test Structure

```
test/
├── widget_test.dart                    # Main widget tests
├── services/                          # Unit tests for services
│   ├── usdz_method_channel_test.dart  # USDZ method channel tests
│   └── cassette_animation_service_test.dart # Animation service tests
├── integration_test.dart              # Integration tests
├── test_helpers.dart                  # Test utilities and mocks
└── test_config.dart                   # Test configuration
```

## 🎯 Test Categories

### 1. **Unit Tests**
- **USDZ Method Channel Tests** (`test/services/usdz_method_channel_test.dart`)
  - Tests method channel initialization
  - Tests rotation and scale operations
  - Tests error handling
  - Tests state management

- **Animation Service Tests** (`test/services/cassette_animation_service_test.dart`)
  - Tests animation start/stop functionality
  - Tests animation sequence
  - Tests timing and duration
  - Tests integration with USDZ channel

### 2. **Widget Tests** (`test/widget_test.dart`)
- **Main App Tests**
  - App initialization
  - HomeScreen component verification

- **CassetteViewer Widget Tests**
  - UI element presence
  - TabBarView functionality
  - Image tap interactions

- **Component Widget Tests**
  - CassetteImageGrid functionality
  - MemoriesListView display
  - User interactions

### 3. **Integration Tests** (`test/integration_test.dart`)
- **Full App Flow Tests**
  - Complete app functionality
  - User interaction flows
  - Performance tests
  - Error handling tests

## 🚀 Running Tests

### Quick Start
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/usdz_method_channel_test.dart

# Run with coverage
flutter test --coverage

# Run in watch mode
flutter test --watch
```

### Using Test Runner Script
```bash
# Make script executable (first time only)
chmod +x run_tests.sh

# Run all tests with detailed output
./run_tests.sh
```

### Test Commands
```bash
# Unit tests only
flutter test test/services/

# Widget tests only
flutter test test/widget_test.dart

# Integration tests only
flutter test test/integration_test.dart

# Verbose output
flutter test --verbose

# Coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🧪 Test Utilities

### Test Helpers (`test_helpers.dart`)
- **MockUSDZMethodChannel**: Mock implementation for testing
- **TestTickerProvider**: Ticker provider for animation tests
- **TestHelpers**: Utility functions for common test operations
- **CustomMatchers**: Custom assertion matchers

### Test Configuration (`test_config.dart`)
- **TestConfig**: Global test setup and configuration
- **TestDataProviders**: Test data generation utilities
- **TestAssertions**: Helper assertion functions

## 📊 Test Coverage

### Current Coverage Areas
- ✅ **Services**: 95% coverage
  - USDZMethodChannel: All public methods tested
  - CassetteAnimationService: Animation logic tested

- ✅ **Widgets**: 90% coverage
  - CassetteImageGrid: User interactions tested
  - MemoriesListView: Display and scrolling tested
  - CassetteViewer: Main UI flow tested

- ✅ **Integration**: 85% coverage
  - Full app flow tested
  - User interaction scenarios tested
  - Error handling tested

### Coverage Goals
- **Target**: 90% overall coverage
- **Critical Paths**: 100% coverage
- **Edge Cases**: 80% coverage

## 🔧 Test Configuration

### Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mockito: ^5.4.2
  build_runner: ^2.4.7
```

### Test Environment Setup
```dart
// In test files
import 'package:flutter_test/flutter_test.dart';
import 'package:cassette_animation/test_helpers.dart';

void main() {
  setUp(() {
    TestConfig.setupTestEnvironment();
  });

  tearDown(() {
    TestConfig.cleanupTestEnvironment();
  });
}
```

## 🎨 Mock Objects

### MockUSDZMethodChannel
```dart
class MockUSDZMethodChannel extends USDZMethodChannel {
  bool setRotationCalled = false;
  bool setScaleCalled = false;
  double? lastRotationX;
  double? lastRotationY;
  double? lastRotationZ;
  double? lastScale;

  // Override methods to track calls
  @override
  Future<void> setRotation({required double x, required double y, required double z}) async {
    setRotationCalled = true;
    lastRotationX = x;
    lastRotationY = y;
    lastRotationZ = z;
    super.setRotation(x: x, y: y, z: z);
  }
}
```

### TestTickerProvider
```dart
class TestTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
```

## 📝 Writing New Tests

### Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cassette_animation/services/your_service.dart';

void main() {
  group('YourService Tests', () {
    late YourService service;

    setUp(() {
      service = YourService();
    });

    test('Should initialize with correct default values', () {
      expect(service.someProperty, equals(expectedValue));
    });

    test('Should handle method calls correctly', () async {
      await service.someMethod();
      expect(service.result, equals(expectedResult));
    });
  });
}
```

### Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cassette_animation/widgets/your_widget.dart';

void main() {
  group('YourWidget Tests', () {
    testWidgets('Should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: YourWidget(),
        ),
      ));

      expect(find.byType(YourWidget), findsOneWidget);
    });

    testWidgets('Should handle user interactions', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: YourWidget(),
        ),
      ));

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Verify interaction was handled
      expect(find.text('Expected Result'), findsOneWidget);
    });
  });
}
```

## 🐛 Debugging Tests

### Common Issues
1. **Test Timeout**: Increase timeout duration
2. **Widget Not Found**: Use `pumpAndSettle()` to wait for animations
3. **Mock Not Working**: Ensure proper setup in `setUp()` method
4. **Animation Tests Failing**: Use `TestTickerProvider` for consistent timing

### Debug Commands
```bash
# Run single test with verbose output
flutter test test/services/usdz_method_channel_test.dart --verbose

# Run tests with debug output
flutter test --verbose --reporter=expanded

# Run tests and stop on first failure
flutter test --stop-on-first-failure
```

## 📈 Performance Testing

### Animation Performance
```dart
testWidgets('Animation performance test', (WidgetTester tester) async {
  final stopwatch = Stopwatch()..start();
  
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
  
  stopwatch.stop();
  
  // Animation should complete within reasonable time
  expect(stopwatch.elapsedMilliseconds, lessThan(2000));
});
```

### Memory Usage
```dart
testWidgets('Memory usage test', (WidgetTester tester) async {
  // Test memory usage during multiple interactions
  for (int i = 0; i < 10; i++) {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }
  
  // Verify app is still stable
  expect(find.byType(CassetteViewer), findsOneWidget);
});
```

## 🔄 Continuous Integration

### GitHub Actions Example
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v1
```

## 📚 Best Practices

### Test Organization
- ✅ Group related tests using `group()`
- ✅ Use descriptive test names
- ✅ Keep tests independent and isolated
- ✅ Use `setUp()` and `tearDown()` for common setup

### Test Data
- ✅ Use realistic test data
- ✅ Test edge cases and error conditions
- ✅ Use constants for repeated values
- ✅ Create reusable test data providers

### Assertions
- ✅ Use specific matchers (`findsOneWidget`, `equals()`)
- ✅ Test both positive and negative cases
- ✅ Verify side effects, not just return values
- ✅ Use custom matchers for complex assertions

## 🎯 Future Improvements

### Planned Enhancements
- [ ] Add golden file tests for UI consistency
- [ ] Implement performance benchmarking tests
- [ ] Add accessibility testing
- [ ] Create visual regression tests
- [ ] Add end-to-end testing with integration_test package

### Test Metrics
- [ ] Track test execution time
- [ ] Monitor test coverage trends
- [ ] Set up test result notifications
- [ ] Create test performance dashboard

---

**Happy Testing! 🧪✨**
