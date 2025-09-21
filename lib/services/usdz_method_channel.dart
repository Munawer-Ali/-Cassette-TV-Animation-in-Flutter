import 'package:flutter/services.dart';

class USDZMethodChannel {
  static const MethodChannel _channel = MethodChannel('usdz_channel');
  
  // Rotation values
  double rotationX = 0.0;
  double rotationY = 0.0;
  double rotationZ = -90.0;
  double scale = 1.0;
  
  // Initialize method call handler
  void initialize() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }
  
  // Handle incoming method calls from iOS
  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'updateValues':
        final Map<String, dynamic> values = Map<String, dynamic>.from(call.arguments);
        rotationX = (values['rotationX'] as num).toDouble();
        rotationY = (values['rotationY'] as num).toDouble();
        rotationZ = (values['rotationZ'] as num).toDouble();
        scale = (values['scale'] as num).toDouble();
        break;
      default:
    }
  }
  
  // Set rotation
  Future<void> setRotation({
    required double x,
    required double y,
    required double z,
  }) async {
    try {
      await _channel.invokeMethod('setRotation', {
        'x': x,
        'y': y,
        'z': z,
      });
      
      // Update local values
      rotationX = x;
      rotationY = y;
      rotationZ = z;
    } catch (e) {
      throw Exception('Error setting rotation: $e');
    }
  }
  
  // Set scale
  Future<void> setScale({required double scale}) async {
    try {
      await _channel.invokeMethod('setScale', {
        'scale': scale,
      });
      
      // Update local value
      this.scale = scale;
    } catch (e) {
      throw Exception('Error setting scale: $e');
    }
  }
  
  // Rotate by relative amounts
  Future<void> rotateBy({
    required double x,
    required double y,
    required double z,
  }) async {
    await setRotation(
      x: rotationX + x,
      y: rotationY + y,
      z: rotationZ + z,
    );
  }
  
  // Zoom in/out
  Future<void> zoomIn() async {
    await _channel.invokeMethod('zoomIn');
  }
  
  Future<void> zoomOut() async {
    await _channel.invokeMethod('zoomOut');
  }
  
  // Get current rotation values
  Map<String, double> getRotationValues() {
    return {
      'x': rotationX,
      'y': rotationY,
      'z': rotationZ,
    };
  }
  
  // Get current scale value
  double getScaleValue() {
    return scale;
  }
}
