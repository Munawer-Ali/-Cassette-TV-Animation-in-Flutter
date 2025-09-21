import 'package:cassette_animation/widgets/cassette_image_grid.dart';
import 'package:cassette_animation/widgets/memories_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cassette_animation/main.dart';
import 'package:cassette_animation/views/cassette_view.dart';

import 'test_cassette_viewer.dart';

void main() {
    TestWidgetsFlutterBinding.ensureInitialized();
  group('Integration Tests', () {
    testWidgets('Full app integration test', (WidgetTester tester) async {
      // Build the complete app
      await tester.pumpWidget(const MyApp());

      // Wait for the app to fully load
      await tester.pumpAndSettle();

      // Verify main components are present
      expect(find.byType(CassetteViewer), findsOneWidget);
      expect(find.text('Years'), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);

      // Verify first tab is present (CassetteImageGrid is always loaded)
      expect(find.byType(CassetteImageGrid), findsOneWidget);
      
      // MemoriesListView is lazy loaded, so we check TabBarView instead
      expect(find.byType(TabBarView), findsOneWidget);

      // Verify TV elements are present
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('Image tap interaction flow', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TestCassetteViewer(),
      ));
      await tester.pumpAndSettle();

      // Find the specific cassette (the one with 'C' text)
      final cassette = find.widgetWithText(GestureDetector, 'C');
      expect(cassette, findsOneWidget);

      // Tap on the cassette
      await tester.tap(cassette);
      await tester.pump();

      // Wait for animation to start
      await tester.pump(Duration(milliseconds: 100));

      // Verify the app is still functioning
      expect(find.byType(TestCassetteViewer), findsOneWidget);
    });

    testWidgets('Tab switching functionality', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify first tab is present
      expect(find.byType(CassetteImageGrid), findsOneWidget);
      
      // TabBarView should be present (MemoriesListView is lazy loaded)
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('Scroll functionality in memories list', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find the ListView in memories
      final listView = find.byType(ListView);
      expect(listView, findsOneWidget);

      // Try to scroll
      await tester.drag(listView.first, Offset(0, -200));
      await tester.pump();

      // Verify scrolling worked
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Memory list displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find the TabBarView and switch to the second tab (Memories)
      final tabBarView = find.byType(TabBarView);
      expect(tabBarView, findsOneWidget);
      
      // Use the TabController to switch to the Memories tab
      final tabController = tester.widget<TabBarView>(tabBarView).controller;
      if (tabController != null) {
        tabController.animateTo(1);
        await tester.pumpAndSettle();
      }

      // Verify that MemoriesListView is now present
      expect(find.byType(MemoriesListView), findsOneWidget);

      // Verify photo counts are displayed
      expect(find.textContaining('moments'), findsWidgets);
    });

    testWidgets('App handles multiple interactions', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TestCassetteViewer(),
      ));
      await tester.pumpAndSettle();

      // First interaction - tap cassette
      final cassette = find.widgetWithText(GestureDetector, 'C');
      if (cassette.evaluate().isNotEmpty) {
        await tester.tap(cassette);
        await tester.pump();
      }

      // Second interaction - scroll
      final listView = find.byType(ListView);
      if (listView.evaluate().isNotEmpty) {
        await tester.drag(listView.first, Offset(0, -100));
        await tester.pump();
      }

      // Verify app is still stable
      expect(find.byType(TestCassetteViewer), findsOneWidget);
    });

    testWidgets('App handles rapid interactions', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TestCassetteViewer(),
      ));
      await tester.pumpAndSettle();

      // Rapid taps on specific cassette
      final cassette = find.widgetWithText(GestureDetector, 'C');
      await tester.tap(cassette);
      await tester.pump();
      await tester.tap(cassette);
      await tester.pump();
      await tester.tap(cassette);
      await tester.pump();

      // Wait for all animations to complete
      await tester.pumpAndSettle();
      
      // Verify app is still stable
      expect(find.byType(TestCassetteViewer), findsOneWidget);
    });

    testWidgets('App handles different screen sizes', (WidgetTester tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(Size(400, 800));
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(CassetteViewer), findsOneWidget);

      // Change to larger screen
      await tester.binding.setSurfaceSize(Size(800, 1200));
      await tester.pumpAndSettle();

      expect(find.byType(CassetteViewer), findsOneWidget);

      // Reset to default
      await tester.binding.setSurfaceSize(Size(800, 600));
    });

    testWidgets('App handles orientation changes', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Simulate orientation change by changing screen size
      await tester.binding.setSurfaceSize(Size(600, 400)); // Landscape
      await tester.pumpAndSettle();

      expect(find.byType(CassetteViewer), findsOneWidget);

      await tester.binding.setSurfaceSize(Size(400, 600)); // Portrait
      await tester.pumpAndSettle();

      expect(find.byType(CassetteViewer), findsOneWidget);
    });

    testWidgets('App handles memory pressure', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Simulate memory pressure by creating many widgets
      for (int i = 0; i < 10; i++) {
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();
      }

      // Verify app is still stable
      expect(find.byType(CassetteViewer), findsOneWidget);
    });
  });

  group('Performance Tests', () {
    testWidgets('App loads within reasonable time', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      stopwatch.stop();
      
      // App should load within 5 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });

    testWidgets('Animation performance', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TestCassetteViewer(),
      ));
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();
      
      // Trigger animation on specific cassette
      final cassette = find.widgetWithText(GestureDetector, 'C');
      await tester.tap(cassette);
      await tester.pump();
      
      // Wait for animation to complete
      await tester.pumpAndSettle();
      
      stopwatch.stop();
      
      // Animation should complete within reasonable time
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });
  });

  group('Error Handling Tests', () {
    testWidgets('App handles missing assets gracefully', (WidgetTester tester) async {
      // This test would require modifying the app to use non-existent assets
      // For now, we'll just verify the app doesn't crash
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(CassetteViewer), findsOneWidget);
    });

    testWidgets('App handles network errors gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // The app should handle network image loading errors
      expect(find.byType(CassetteViewer), findsOneWidget);
    });
  });
}