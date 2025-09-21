import 'package:flutter_test/flutter_test.dart';

/// Test configuration and setup for cassette animation tests
class TestConfig {
  /// Setup test environment
  static void setupTestEnvironment() {
    // Set up any global test configuration here
    TestWidgetsFlutterBinding.ensureInitialized();
  }

  /// Cleanup after tests
  static void cleanupTestEnvironment() {
    // Cleanup any global test state here
  }

  /// Default test timeout
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Animation test timeout
  static const Duration animationTimeout = Duration(seconds: 5);

  /// Integration test timeout
  static const Duration integrationTimeout = Duration(seconds: 60);
}

/// Test data providers
class TestDataProviders {
  /// Provides test image lists
  static List<String> getTestImageList({int count = 6}) {
    return List.generate(count, (index) => 'assets/cassette.png');
  }

  /// Provides test photo counts
  static List<int> getTestPhotoCounts() {
    return [3, 5, 2, 4, 6, 3];
  }

  /// Provides test image indices
  static List<List<int>> getTestImageIndices() {
    return [
      [0, 1, 2],
      [3, 4, 5, 6, 7],
      [8, 9],
      [0, 1, 2, 3],
      [4, 5, 6, 7, 8, 9],
      [0, 1, 2],
    ];
  }

  /// Provides test image URLs
  static List<String> getTestImageUrls() {
    return List.generate(10, (index) => 'https://picsum.photos/200/300?random=${index + 1}');
  }
}

/// Test assertions helpers
class TestAssertions {
  /// Asserts that a widget is visible
  static void assertWidgetVisible(Finder finder) {
    expect(finder, findsOneWidget);
  }

  /// Asserts that a widget is not visible
  static void assertWidgetNotVisible(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Asserts that multiple widgets are visible
  static void assertWidgetsVisible(Finder finder) {
    expect(finder, findsWidgets);
  }

  /// Asserts that text is visible
  static void assertTextVisible(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Asserts that text is not visible
  static void assertTextNotVisible(String text) {
    expect(find.text(text), findsNothing);
  }
}
