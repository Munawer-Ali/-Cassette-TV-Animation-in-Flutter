import 'package:cassette_animation/views/cassette_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cassette_animation/services/usdz_method_channel.dart';
import 'package:cassette_animation/services/cassette_animation_service.dart';

/// Test utilities for cassette animation tests
class TestHelpers {
  /// Creates a mock USDZ method channel for testing
  static MockUSDZMethodChannel createMockUSDZChannel() {
    return MockUSDZMethodChannel();
  }

  /// Creates a test ticker provider for animation tests
  static TestTickerProvider createTestTickerProvider() {
    return TestTickerProvider();
  }

  /// Creates a cassette animation service for testing
  static CassetteAnimationService createTestAnimationService({
    USDZMethodChannel? usdzChannel,
    TickerProvider? tickerProvider,
  }) {
    final channel = usdzChannel ?? createMockUSDZChannel();
    final ticker = tickerProvider ?? createTestTickerProvider();
    
    return CassetteAnimationService(
      vsync: ticker,
      usdzChannel: channel,
    );
  }

  /// Waits for animation to complete
  static Future<void> waitForAnimation(WidgetTester tester) async {
    await tester.pump(Duration(milliseconds: 1000));
  }

  /// Simulates image tap interaction
  static Future<void> tapCassetteImage(WidgetTester tester) async {
    final cassetteImages = find.byType(Image);
    if (cassetteImages.evaluate().isNotEmpty) {
      await tester.tap(cassetteImages.first);
      await tester.pump();
    }
  }

  /// Simulates scroll interaction
  static Future<void> scrollMemoriesList(WidgetTester tester) async {
    final listView = find.byType(ListView);
    if (listView.evaluate().isNotEmpty) {
      await tester.drag(listView.first, Offset(0, -200));
      await tester.pump();
    }
  }

  /// Verifies app is in stable state
  static void verifyAppStability(WidgetTester tester) {
    expect(find.byType(CassetteViewer), findsOneWidget);
    expect(find.text('Years'), findsOneWidget);
  }

  /// Creates test data for memories list
  static TestMemoriesData createTestMemoriesData() {
    return TestMemoriesData();
  }

  /// Creates test data for image grid
  static TestImageGridData createTestImageGridData() {
    return TestImageGridData();
  }
}

/// Mock USDZ method channel for testing
class MockUSDZMethodChannel extends USDZMethodChannel {
  bool setRotationCalled = false;
  bool setScaleCalled = false;
  bool zoomInCalled = false;
  bool zoomOutCalled = false;
  double? lastRotationX;
  double? lastRotationY;
  double? lastRotationZ;
  double? lastScale;

  @override
  Future<void> setRotation({
    required double x,
    required double y,
    required double z,
  }) async {
    setRotationCalled = true;
    lastRotationX = x;
    lastRotationY = y;
    lastRotationZ = z;
    super.setRotation(x: x, y: y, z: z);
  }

  @override
  Future<void> setScale({required double scale}) async {
    setScaleCalled = true;
    lastScale = scale;
    super.setScale(scale: scale);
  }

  @override
  Future<void> zoomIn() async {
    zoomInCalled = true;
  }

  @override
  Future<void> zoomOut() async {
    zoomOutCalled = true;
  }

  /// Reset mock state
  void reset() {
    setRotationCalled = false;
    setScaleCalled = false;
    zoomInCalled = false;
    zoomOutCalled = false;
    lastRotationX = null;
    lastRotationY = null;
    lastRotationZ = null;
    lastScale = null;
  }
}

/// Test ticker provider for animation tests
class TestTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

/// Test data for memories list
class TestMemoriesData {
  final List<int> photoCounts = [3, 5, 2, 4, 6, 3];
  final List<List<int>> imageIndices = [
    [0, 1, 2],
    [3, 4, 5, 6, 7],
    [8, 9],
    [0, 1, 2, 3],
    [4, 5, 6, 7, 8, 9],
    [0, 1, 2],
  ];
  final List<String> imageUrls = [
    'https://picsum.photos/200/300?random=1',
    'https://picsum.photos/200/300?random=2',
    'https://picsum.photos/200/300?random=3',
    'https://picsum.photos/200/300?random=4',
    'https://picsum.photos/200/300?random=5',
  ];
}

/// Test data for image grid
class TestImageGridData {
  final List<String> imageList = [
    'assets/cassette.png',
    'assets/cassette.png',
    'assets/cassette.png',
    'assets/cassette.png',
    'assets/cassette.png',
    'assets/cassette.png',
  ];

  List<GlobalKey> get imageKeys => 
      List.generate(imageList.length, (index) => GlobalKey());
}

/// Custom matchers for testing
class CustomMatchers {
  /// Matches if a double is within a certain range
  static Matcher isInRange(double min, double max) {
    return predicate<double>(
      (value) => value >= min && value <= max,
      'is in range [$min, $max]',
    );
  }

  /// Matches if a string contains any of the given substrings
  static Matcher containsAny(List<String> substrings) {
    return predicate<String>(
      (value) => substrings.any((substring) => value.contains(substring)),
      'contains any of $substrings',
    );
  }
}

/// Test constants
class TestConstants {
  static const Duration animationDuration = Duration(milliseconds: 800);
  static const Duration shortDelay = Duration(milliseconds: 100);
  static const Duration longDelay = Duration(milliseconds: 1000);
  
  static const double minRotation = -360.0;
  static const double maxRotation = 360.0;
  static const double minScale = 0.1;
  static const double maxScale = 5.0;
  
  static const List<String> monthNames = [
    'January', 'February', 'March', 
    'April', 'May', 'June'
  ];
}
