# 🎵 Cassette Animation Flutter App

A beautiful Flutter application that creates an interactive cassette tape animation with 3D USDZ model integration, image galleries, and smooth transitions.

## 📱 Features

- **3D Cassette Model**: Interactive USDZ model with rotation and scaling animations
- **Image Gallery**: Grid-based cassette image selection with smooth transitions
- **Memories Timeline**: Monthly photo collections with random image generation
- **TV Animation**: Dynamic TV screen with rotating images
- **Smooth Transitions**: Fluid animations between different states
- **Clean Architecture**: Well-organized code with service-based architecture

## 🏗️ Project Structure

```
lib/
├── main.dart                           # App entry point
├── services/                           # Business logic services
│   ├── usdz_method_channel.dart       # USDZ communication service
│   └── cassette_animation_service.dart # Animation management
├── views/                              # Main UI screens
│   └── cassette_view.dart             # Main cassette viewer
└── widgets/                            # Reusable UI components
    ├── cassette_image_grid.dart       # Image grid component
    └── memories_list_view.dart         # Memories timeline component

ios/Runner/
├── AppDelegate.swift                   # iOS app delegate with plugin registration
└── USDZView.swift                     # USDZ 3D model view implementation

assets/
├── cassette.png                       # Cassette tape images
├── TV.png                             # TV frame image
├── TV_Cutout.png                      # TV cutout overlay
└── model.usdz                         # 3D cassette model
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- iOS development environment (Xcode)
- macOS for iOS development

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd cassette_animation
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🎯 Core Components

### USDZ Method Channel Service

The `USDZMethodChannel` class handles all communication between Flutter and the native iOS USDZ view:

```dart
// Initialize the service
final usdzChannel = USDZMethodChannel();
usdzChannel.initialize();

// Set rotation
await usdzChannel.setRotation(x: -90.0, y: 0.0, z: 0.0);

// Set scale
await usdzChannel.setScale(scale: 0.8);

// Relative rotation
await usdzChannel.rotateBy(x: 15.0, y: 0.0, z: 0.0);
```

**Available Methods:**
- `setRotation(x, y, z)` - Set absolute rotation in degrees
- `setScale(scale)` - Set model scale (0.1 to 2.0)
- `rotateBy(x, y, z)` - Rotate by relative amounts
- `zoomIn()` / `zoomOut()` - Camera zoom controls
- `getRotationValues()` - Get current rotation state
- `getScaleValue()` - Get current scale value

### Animation Service

The `CassetteAnimationService` manages the smooth cassette rotation animation:

```dart
// Initialize with TickerProvider
final animationService = CassetteAnimationService(
  vsync: this,
  usdzChannel: usdzChannel,
);

// Start animation
animationService.startAnimation();

// Stop animation
animationService.stopAnimation();

// Check animation state
bool isAnimating = animationService.isAnimating;
```

**Animation Sequence:**
1. **Start**: `(0°, 0°, -90°)` - Initial position
2. **Step 1**: `(-30°, 0°, -60°)` - First rotation
3. **Step 2**: `(-60°, 0°, -30°)` - Second rotation
4. **Step 3**: `(-65°, 0°, -15°)` - Third rotation
5. **End**: `(-90°, 0°, 0°)` - Final position

### UI Components

#### Cassette Image Grid
```dart
CassetteImageGrid(
  imageList: imageList,
  onImageTap: (index) => handleImageTap(index),
  imageKeys: imageKeys,
)
```

#### Memories List View
```dart
MemoriesListView(
  scrollController: scrollController,
  randomPhotoCounts: photoCounts,
  randomImageIndices: imageIndices,
  randomImageUrls: imageUrls,
)
```

## 🎨 User Interface

### Main Screen Layout

1. **TV Frame**: Top section with TV cutout and overlay images
2. **Image Grid**: 3x3 grid of cassette images (Tab 1)
3. **Memories Timeline**: Monthly photo collections (Tab 2)
4. **3D Model**: USDZ cassette model with animations
5. **Image Overlay**: Selected image follows animation

### Animation Flow

1. **Image Selection**: User taps on cassette image
2. **Position Animation**: Model moves to image position
3. **Rotation Animation**: Smooth 4-step rotation sequence
4. **TV Transition**: TV screen shows rotating images
5. **Tab Switch**: Automatically switches to memories tab
6. **Scroll Animation**: Smooth scroll to bottom of memories

## 🔧 iOS Integration

### USDZ View Implementation

The iOS `USDZView` class handles 3D model rendering:

```swift
// Model loading with automatic scaling
guard let modelScene = try? SCNScene(named: "Assets.scnassets/model.usdz") else {
    print("❌ Could not load model.usdz")
    return
}

// Automatic model normalization
let (minVec, maxVec) = modelNode.boundingBox
let maxDimension = max(size.x, max(size.y, size.z))
let scaleFactor = targetSize / maxDimension
modelNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
```

### Method Channel Handlers

- `setRotation` - Set absolute rotation (degrees to radians conversion)
- `setScale` - Set model scale
- `rotateX/Y/Z` - Relative rotation actions
- `zoomIn/Out` - Camera zoom controls

## 🧪 Testing

This project includes a comprehensive test suite with 52 tests covering all major functionality:

### Test Structure

```
test/
├── widget_test.dart                    # Main widget tests (13 tests)
├── integration_test.dart              # Integration tests (14 tests)
├── test_cassette_viewer.dart          # Test-specific widget for timer cleanup
├── services/                          # Service unit tests
│   ├── usdz_method_channel_test.dart  # USDZ service tests (12 tests)
│   └── cassette_animation_service_test.dart # Animation service tests (13 tests)
├── test_helpers.dart                  # Common test utilities and mocks
├── test_config.dart                   # Test configuration and setup
└── run_tests.sh                       # Test runner script
```

### Test Coverage

- **✅ Service Tests (25 tests)**: Complete coverage of `USDZMethodChannel` and `CassetteAnimationService`
- **✅ Widget Tests (13 tests)**: All UI components tested for proper behavior
- **✅ Integration Tests (14 tests)**: Full app functionality and user interactions

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test files
flutter test test/widget_test.dart
flutter test test/services/
flutter test test/integration_test.dart

# Run with coverage
flutter test --coverage

# Use the test runner script
chmod +x run_tests.sh
./run_tests.sh
```

### Test Documentation

For detailed information about the test suite, see **[TEST_DOCUMENTATION.md](TEST_DOCUMENTATION.md)** which includes:

- **Test Architecture**: How tests are organized and structured
- **Writing Tests**: Guidelines for creating new tests
- **Mocking**: How to use mocks and test utilities
- **Best Practices**: Testing patterns and recommendations
- **Debugging**: Tips for troubleshooting test failures
- **CI/CD Integration**: Setting up automated testing

### Key Testing Features

- **Timer Management**: Proper cleanup of `Future.delayed` timers in tests
- **Platform Channel Mocking**: Safe testing of iOS method channels
- **Animation Testing**: Comprehensive animation state and sequence testing
- **Widget Testing**: UI component behavior and interaction testing
- **Integration Testing**: Full app workflow and user journey testing

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_inappwebview: ^6.1.5
  media_kit_video: ^1.3.0
  media_kit: ^1.2.0
  media_kit_libs_video: ^1.0.6
  media_kit_libs_android_video: ^1.3.7

```

## 🎬 Animation Details

### Position Animation Timeline

- **0ms**: Stop current animation, hide TV images
- **500ms**: Move model to left position (-20px)
- **1300ms**: Start rotation animation, move to center (118px)
- **1900ms**: Adjust vertical position (+17px)
- **2200ms**: Hide top TV overlay
- **2500ms**: Enable cassette down animation
- **2600ms**: Show TV images, switch to memories tab, scroll to bottom

### Rotation Animation

- **Duration**: 800ms total
- **Segments**: 4 smooth transitions
- **Easing**: `Curves.easeInOut`
- **Scale Change**: Model scales to 84% during step 3

## 🛠️ Development

### Adding New Features

1. **New Animation**: Extend `CassetteAnimationService`
2. **New UI Component**: Create in `widgets/` directory
3. **New Service**: Add to `services/` directory
4. **New Method**: Add to `USDZMethodChannel`

### Code Organization

- **Services**: Business logic and external communication
- **Views**: Main UI screens and state management
- **Widgets**: Reusable UI components
- **Models**: Data structures and constants

## 🐛 Troubleshooting

### Common Issues

1. **USDZ Model Not Loading**
   - Check if `model.usdz` exists in `ios/Runner/Assets.xcassets/`
   - Verify iOS bundle includes the file

2. **Method Channel Errors**
   - Ensure `USDZView` is properly registered in `AppDelegate.swift`
   - Check method names match between Flutter and iOS

3. **Animation Not Smooth**
   - Verify `TickerProvider` is properly implemented
   - Check animation duration and curve settings

### Debug Tips

- Use `print()` statements in method channel handlers
- Check iOS console for USDZ loading errors
- Verify animation controller state in Flutter

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 Support

For support and questions:
- Create an issue in the repository
- Check the troubleshooting section
- Review the code documentation

---

**Built with ❤️ using Flutter and SceneKit**