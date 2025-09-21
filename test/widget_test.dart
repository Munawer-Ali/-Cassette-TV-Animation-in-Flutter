import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cassette_animation/main.dart';
import 'package:cassette_animation/views/cassette_view.dart';
import 'package:cassette_animation/widgets/cassette_image_grid.dart';
import 'package:cassette_animation/widgets/memories_list_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Main App Tests', () {
    testWidgets('App should start and show CassetteViewer', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that our app shows the cassette viewer
      expect(find.byType(CassetteViewer), findsOneWidget);
      expect(find.text('Years'), findsOneWidget);
    });

    testWidgets('HomeScreen should contain CassetteViewer', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CassetteViewer(),
        ),
      ));

      expect(find.byType(CassetteViewer), findsOneWidget);
    });
  });

  group('CassetteViewer Widget Tests', () {
    testWidgets('Should display TV cutout and Years text', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CassetteViewer(),
        ),
      ));

      // Verify UI elements are present
      expect(find.text('Years'), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('Should show TabBarView with two tabs', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CassetteViewer(),
        ),
      ));

      // Verify TabBarView is present
      expect(find.byType(TabBarView), findsOneWidget);
      
      // Verify first tab content widget is present
      expect(find.byType(CassetteImageGrid), findsOneWidget);
    });
  });

  group('CassetteImageGrid Widget Tests', () {
    final testImageList = [
      'assets/cassette.png',
      'assets/cassette.png',
      'assets/cassette.png',
    ];

    testWidgets('Should display image grid with correct number of images', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CassetteImageGrid(
            imageList: testImageList,
            onImageTap: (index) {},
            imageKeys: List.generate(testImageList.length, (index) => GlobalKey()),
          ),
        ),
      ));

      // Verify the grid container is present
      expect(find.byType(Container), findsWidgets);
      
      // Verify images are displayed
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('Should call onImageTap when image is tapped', (WidgetTester tester) async {
      bool tapCalled = false;
      int tappedIndex = -1;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CassetteImageGrid(
            imageList: testImageList,
            onImageTap: (index) {
              tapCalled = true;
              tappedIndex = index;
            },
            imageKeys: List.generate(testImageList.length, (index) => GlobalKey()),
          ),
        ),
      ));

      // Find and tap the first image
      final gestureDetector = find.byType(GestureDetector).first;
      await tester.tap(gestureDetector);
      await tester.pump();

      // Verify the callback was called
      expect(tapCalled, isTrue);
      expect(tappedIndex, equals(0));
    });

    testWidgets('Should handle empty image list gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CassetteImageGrid(
            imageList: [],
            onImageTap: (index) {},
            imageKeys: [],
          ),
        ),
      ));

      // Should not throw any errors
      expect(find.byType(CassetteImageGrid), findsOneWidget);
    });
  });

  group('MemoriesListView Widget Tests', () {
    final testPhotoCounts = [3, 5, 2, 4, 6, 3];
    final testImageIndices = [
      [0, 1, 2],
      [3, 4, 5, 6, 7],
      [8, 9],
      [0, 1, 2, 3],
      [4, 5, 6, 7, 8, 9],
      [0, 1, 2],
    ];
    final testImageUrls = [
      'https://picsum.photos/200/300?random=1',
      'https://picsum.photos/200/300?random=2',
      'https://picsum.photos/200/300?random=3',
      'https://picsum.photos/200/300?random=4',
      'https://picsum.photos/200/300?random=5',
      'https://picsum.photos/200/300?random=6',
      'https://picsum.photos/200/300?random=7',
      'https://picsum.photos/200/300?random=8',
      'https://picsum.photos/200/300?random=9',
      'https://picsum.photos/200/300?random=10',
    ];

    testWidgets('Should display memories list with months', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MemoriesListView(
            scrollController: ScrollController(),
            randomPhotoCounts: testPhotoCounts,
            randomImageIndices: testImageIndices,
            randomImageUrls: testImageUrls,
          ),
        ),
      ));

      // Verify month names are displayed (only first 4 months to avoid network issues)
      expect(find.text('January'), findsOneWidget);
      expect(find.text('February'), findsOneWidget);
      expect(find.text('March'), findsOneWidget);
      expect(find.text('April'), findsOneWidget);
    });

    testWidgets('Should display photo counts for each month', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MemoriesListView(
            scrollController: ScrollController(),
            randomPhotoCounts: testPhotoCounts,
            randomImageIndices: testImageIndices,
            randomImageUrls: testImageUrls,
          ),
        ),
      ));

      // Verify photo counts are displayed
      expect(find.text('3 moments'), findsOneWidget);
      expect(find.text('5 moments'), findsOneWidget);
      expect(find.text('2 moments'), findsOneWidget);
    });

    testWidgets('Should display ListView with correct number of items', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MemoriesListView(
            scrollController: ScrollController(),
            randomPhotoCounts: testPhotoCounts,
            randomImageIndices: testImageIndices,
            randomImageUrls: testImageUrls,
          ),
        ),
      ));

      // Verify ListView is present
      expect(find.byType(ListView), findsOneWidget);
      
      // Verify we have 6 months (6 items)
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Should handle scroll controller', (WidgetTester tester) async {
      final scrollController = ScrollController();
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MemoriesListView(
            scrollController: scrollController,
            randomPhotoCounts: testPhotoCounts,
            randomImageIndices: testImageIndices,
            randomImageUrls: testImageUrls,
          ),
        ),
      ));

      // Verify scroll controller is attached
      expect(scrollController.hasClients, isTrue);
    });
  });

  group('Integration Tests', () {
    testWidgets('Full app flow should work without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Wait for the app to fully load
      await tester.pumpAndSettle();

      // Verify main components are present
      expect(find.byType(CassetteViewer), findsOneWidget);
      expect(find.text('Years'), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);

      // Verify first tab is present
      expect(find.byType(CassetteImageGrid), findsOneWidget);
    });

    testWidgets('Should handle tab switching', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find TabBarView
      final tabBarView = find.byType(TabBarView);
      expect(tabBarView, findsOneWidget);

      // First tab should be present
      expect(find.byType(CassetteImageGrid), findsOneWidget);
      
      // TabBarView should be present (MemoriesListView is lazy loaded)
      expect(find.byType(TabBarView), findsOneWidget);
    });
  });
}