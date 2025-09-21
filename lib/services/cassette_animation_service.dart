import 'package:flutter/material.dart';
import 'usdz_method_channel.dart';

class CassetteAnimationService {
  final USDZMethodChannel _usdzChannel;
  late AnimationController _animationController;
  bool _isAnimating = false;
  
  // Animation sequence for cassette rotation
  final List<Map<String, double>> _animationSequence = [
    {'x': 0.0, 'z': -90.0},    // Starting position
    {'x': -30.0, 'z': -60.0},   // Step 1
    {'x': -60.0, 'z': -30.0},   // Step 2
    {'x': -65.0, 'z': -15.0},   // Step 3
    {'x': -90.0, 'z': 0.0},     // Step 4
  ];
  
  CassetteAnimationService({
    required TickerProvider vsync,
    required USDZMethodChannel usdzChannel,
  }) : _usdzChannel = usdzChannel {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        stopAnimation();
      }
    });
  }
  
  // Start the continuous smooth animation
  void startAnimation() {
    if (_isAnimating) return;
    
    _isAnimating = true;
    _animationController.forward();
    
    final Animation<double> animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    animation.addListener(() {
      if (!_isAnimating) return;
      
      final progress = animation.value;
      final totalSegments = 4;
      final segmentProgress = progress * totalSegments;
      final currentSegment = segmentProgress.floor();
      final segmentFraction = segmentProgress - currentSegment;
      
      double newX, newZ;
      
      switch (currentSegment) {
        case 0: // 0 -> 1
          newX = _animationSequence[0]['x']! + (_animationSequence[1]['x']! - _animationSequence[0]['x']!) * segmentFraction;
          newZ = _animationSequence[0]['z']! + (_animationSequence[1]['z']! - _animationSequence[0]['z']!) * segmentFraction;
          break;
        case 1: // 1 -> 2
          newX = _animationSequence[1]['x']! + (_animationSequence[2]['x']! - _animationSequence[1]['x']!) * segmentFraction;
          newZ = _animationSequence[1]['z']! + (_animationSequence[2]['z']! - _animationSequence[1]['z']!) * segmentFraction;
          break;
        case 2: // 2 -> 3
          newX = _animationSequence[2]['x']! + (_animationSequence[3]['x']! - _animationSequence[2]['x']!) * segmentFraction;
          newZ = _animationSequence[2]['z']! + (_animationSequence[3]['z']! - _animationSequence[2]['z']!) * segmentFraction;
          break;
        case 3: // 3 -> 4
          newX = _animationSequence[3]['x']! + (_animationSequence[4]['x']! - _animationSequence[3]['x']!) * segmentFraction;
          newZ = _animationSequence[3]['z']! + (_animationSequence[4]['z']! - _animationSequence[3]['z']!) * segmentFraction;
          break;
        default:
          newX = -90;
          newZ = 0;
          break;
      }
      
      // Send rotation command to iOS
      _usdzChannel.setRotation(x: newX, y: 0.0, z: newZ);
    });
  }
  
  // Stop the animation
  void stopAnimation() {
    _isAnimating = false;
    _animationController.stop();
    _animationController.reset();
  }
  
  // Check if currently animating
  bool get isAnimating => _isAnimating;
  
  // Dispose resources
  void dispose() {
    _animationController.dispose();
  }
}
