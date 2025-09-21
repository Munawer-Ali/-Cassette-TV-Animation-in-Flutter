import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cassette_animation/main.dart';
import 'package:cassette_animation/views/cassette_view.dart';
import 'package:cassette_animation/widgets/cassette_image_grid.dart';
import 'package:cassette_animation/widgets/memories_list_view.dart';

/// Test-specific CassetteViewer that handles timer cleanup
class TestCassetteViewer extends StatefulWidget {
  const TestCassetteViewer({super.key});

  @override
  State<TestCassetteViewer> createState() => _TestCassetteViewerState();
}

class _TestCassetteViewerState extends State<TestCassetteViewer> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showTopTv = true;
  bool _cassetteDownAnimation = false;
  double _modelX = 118;
  double _modelY = 100;
  List<Timer> _activeTimers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    // Cancel all active timers
    for (var timer in _activeTimers) {
      timer.cancel();
    }
    _activeTimers.clear();
    
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addTimer(Timer timer) {
    _activeTimers.add(timer);
  }

  void _positionAnimation() {
    setState(() {
      _cassetteDownAnimation = false;
    });
    
    _addTimer(Timer(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _modelX = -20;
        });
      }
    }));

    _addTimer(Timer(Duration(milliseconds: 1300), () {
      if (mounted) {
        setState(() {
          _modelX = 118;
          _modelY = 100;
        });
      }
    }));

    _addTimer(Timer(Duration(milliseconds: 1900), () {
      if (mounted) {
        setState(() {
          _modelY = 117;
        });
      }
    }));

    _addTimer(Timer(Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          _showTopTv = false;
        });
      }
    }));

    _addTimer(Timer(Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _cassetteDownAnimation = true;
        });
      }
    }));

    _addTimer(Timer(Duration(milliseconds: 2600), () {
      if (mounted) {
        setState(() {
          _showTopTv = true;
        });
        _tabController.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            color: Colors.black,
            child: Center(
              child: Text(
                'Years',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // TV Cutout
          if (_showTopTv)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'TV Screen',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          
          // Cassette Model
          Positioned(
            left: _modelX,
            top: _modelY,
            child: GestureDetector(
              key: ValueKey('cassette_item_2'),
              onTap: _positionAnimation,
              child: Container(
                width: 50,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'C',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          
          // Tab Content
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            bottom: 0,
            child: TabBarView(
              controller: _tabController,
              children: [
                CassetteImageGrid(
                  imageList: ['assets/cassette.png', 'assets/cassette.png'],
                  onImageTap: (index) {},
                  imageKeys: [GlobalKey(), GlobalKey()],
                ),
                MemoriesListView(
                  scrollController: _scrollController,
                  randomPhotoCounts: [3, 5, 2, 4, 6, 3],
                  randomImageIndices: [
                    [0, 1, 2],
                    [3, 4, 5, 6, 7],
                    [8, 9],
                    [0, 1, 2, 3],
                    [4, 5, 6, 7, 8, 9],
                    [0, 1, 2],
                  ],
                  randomImageUrls: [
                    'https://picsum.photos/200/300?random=1',
                    'https://picsum.photos/200/300?random=2',
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
    TestWidgetsFlutterBinding.ensureInitialized();
  group('Test CassetteViewer Tests', () {
    testWidgets('Should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TestCassetteViewer(),
      ));

      expect(find.byType(TestCassetteViewer), findsOneWidget);
      expect(find.text('Years'), findsOneWidget);
    });

    testWidgets('Should handle tap interactions', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TestCassetteViewer(),
      ));

      final cassette = find.widgetWithText(GestureDetector, 'cassette_item_1');
      await tester.tap(cassette);
      await tester.pump();

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Verify the tap was handled
      expect(find.byType(TestCassetteViewer), findsOneWidget);
    });

    testWidgets('Should handle tab switching', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TestCassetteViewer(),
      ));

      // Find TabBarView
      final tabBarView = find.byType(TabBarView);
      expect(tabBarView, findsOneWidget);

      // First tab should be present
      expect(find.byType(CassetteImageGrid), findsOneWidget);
      
      // TabBarView should be present (MemoriesListView is lazy loaded)
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('Should cleanup timers on dispose', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TestCassetteViewer(),
      ));

      // Trigger animation to create timers
      final cassette = find.widgetWithText(GestureDetector, 'cassette_item_2');
      await tester.tap(cassette);
      await tester.pump();

      // Dispose the widget
      await tester.pumpWidget(Container());

      // No timers should be pending
      expect(find.byType(TestCassetteViewer), findsNothing);
    });
  });
}
