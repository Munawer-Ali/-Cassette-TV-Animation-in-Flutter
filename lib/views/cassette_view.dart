import 'dart:async';
import 'dart:math';
import 'package:cassette_animation/services/cassette_animation_service.dart';
import 'package:cassette_animation/services/usdz_method_channel.dart';
import 'package:cassette_animation/widgets/cassette_image_grid.dart';
import 'package:cassette_animation/widgets/memories_list_view.dart';
import 'package:flutter/material.dart';

final List<String> imageList = [
  'assets/cassette.png',
  'assets/cassette.png',
  'assets/cassette.png',
  'assets/cassette.png',
  'assets/cassette.png',
  'assets/cassette.png',
  'assets/cassette.png',
  'assets/cassette.png',
];

final List<String> randomImageUrls = [
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

class CassetteViewer extends StatefulWidget {
  const CassetteViewer({super.key});

  @override
  State<CassetteViewer> createState() => _CassetteViewerState();
}

class _CassetteViewerState extends State<CassetteViewer> with TickerProviderStateMixin {
  // Services
  late USDZMethodChannel _usdzChannel;
  late CassetteAnimationService _animationService;
  
  // Controllers
  late ScrollController _scrollController;
  late TabController _tabController;
  
  // State variables
  int selectedImageIndex = 0;
  late List<int> _randomPhotoCounts;
  late List<List<int>> _randomImageIndices;
  Timer ? _tvImagesTimer;


  // 3D Model position variables
  double _modelX = 0;
  double _modelY = 0;
  double _imageX = 0;
  double _imageY = 0;
  double _imageWidth = 0;
  double _imageHeight = 0;
  double _modelWidth = 100;
  double _modelHeight = 0;
  bool _showTopTv = true;
  bool _cassetteDownAnimation = true;
  
  // Global keys for each image to get exact positions
  final List<GlobalKey> _imageKeys = List.generate(imageList.length, (index) => GlobalKey());
  final ValueNotifier<String> _tvImages = ValueNotifier('');
  @override
  void initState() {
    super.initState();
    
    // Initialize services
    _usdzChannel = USDZMethodChannel();
    _usdzChannel.initialize();
    
    _animationService = CassetteAnimationService(
      vsync: this,
      usdzChannel: _usdzChannel,
    );
    
    // Initialize controllers
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    
    // Generate random values once during initialization
    _randomPhotoCounts = List.generate(6, (index) => 2 + Random().nextInt(9));
    _randomImageIndices = List.generate(6, (index) {
      int photoCount = 2 + Random().nextInt(9);
      return List.generate(photoCount, (photoIndex) => Random().nextInt(randomImageUrls.length));
    });
    
    // Ensure both arrays have matching lengths
    for (int i = 0; i < 6; i++) {
      _randomPhotoCounts[i] = _randomImageIndices[i].length;
    }
  }


  void _updateTvImages() {
    _tvImagesTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      _tvImages.value = randomImageUrls[Random().nextInt(randomImageUrls.length)];
    });
  }
  
    void _stopTvImages() {
      _tvImagesTimer?.cancel();
      _tvImages.value = '';
    }
  @override
  void dispose() {
    _tvImagesTimer?.cancel();
    _animationService.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _positionAnimation() async {
    _animationService.stopAnimation();
    _stopTvImages();
    setState(() => _cassetteDownAnimation = false);

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _modelX = -20);

    await Future.delayed(const Duration(milliseconds: 800));
    _animationService.startAnimation();
    setState(() {
      _modelX = 118;
      _modelY = MediaQuery.of(context).padding.top + 100;
    });

    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _modelY = MediaQuery.of(context).padding.top + 117;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _showTopTv = false);

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _cassetteDownAnimation = true);

    await Future.delayed(const Duration(milliseconds: 100));
    _updateTvImages();
    setState(() => _showTopTv = true);

    _tabController.animateTo(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);

    // Add smooth scroll animation after tab change
    Future.delayed(const Duration(milliseconds: 600), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onImageTappedWithKey(int imageIndex) {
    final GlobalKey key = _imageKeys[imageIndex];
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    
    if (renderBox != null) {
      final Offset position = renderBox.localToGlobal(Offset.zero);
      final Size size = renderBox.size;
      
      setState(() {
        _imageX = position.dx;
        _imageY = position.dy;
        _imageWidth = size.width;
        _imageHeight = size.height;
        _modelX = position.dx - (size.width * 0.4);
        _modelY = position.dy + (size.height * 0.1);
        _modelWidth = size.width * 1.5;
        _modelHeight = size.height * 1;
        selectedImageIndex = imageIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 230, 230, 231),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              
              // TV Cutout
              SizedBox(
                height: 260,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100,
                    color: Color.fromARGB(255, 220, 220, 224),
                  ),
                ),
              ),
              Container(
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      spreadRadius: 30,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text('Years', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              
              // Tab View
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Page 1 - Cassette Grid
                            CassetteImageGrid(
                              imageList: imageList,
                              onImageTap: (index) {
                                _onImageTappedWithKey(index);
                                _positionAnimation();
                              },
                              imageKeys: _imageKeys,
                            ),
                            
                            // Page 2 - Memories
                            MemoriesListView(
                              scrollController: _scrollController,
                              randomPhotoCounts: _randomPhotoCounts,
                              randomImageIndices: _randomImageIndices,
                              randomImageUrls: randomImageUrls,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // TV Images
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/TV.png',
              color: _showTopTv == true && _cassetteDownAnimation == true ? Colors.white38 : Colors.black,
              height: 250,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Image.asset('assets/TV_Cutout.png', height: 250),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showTopTv ? 1 : 0,
              duration: Duration(milliseconds: 300),
              child: Image.asset('assets/TV.png', height: 250),
            ),
          ),
            Positioned(top: MediaQuery.of(context).padding.top + 20,left: 0,right: 0,child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),child: tvStartAnimation()),
              )),

          // 3D Model positioned based on tap
          _showTopTv == true && _cassetteDownAnimation == true ? SizedBox.shrink() :
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              right: _modelX,
              top: _modelY - 3,
              width: _modelWidth,
              height: _modelHeight - 20,
              child: AnimatedOpacity(
                opacity: !_cassetteDownAnimation ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: IgnorePointer(
                  child: UiKitView(
                    viewType: "USDZView",
                  ),
                ),
              ),
            ),
          
          // Selected image overlay
          _cassetteDownAnimation == true ? SizedBox() :
            Positioned(
              top: _imageY,
              right: _imageX,
              width: _imageWidth,
              height: _imageHeight,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.transparent),
                  color: Colors.transparent,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imageList[selectedImageIndex],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[600],
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  Widget tvStartAnimation() {
    return ValueListenableBuilder(
      valueListenable: _tvImages,
      builder: (context, value, child) {
        if(value.isEmpty) return SizedBox();
        return Image.network(value,height: 145,width: 200,fit: BoxFit.fill,);
      },
    );
  }
}
