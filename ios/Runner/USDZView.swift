import UIKit
import SceneKit
import Flutter

class USDZView: NSObject, FlutterPlatformView {
    private var sceneView: SCNView
    private var modelNode: SCNNode?

    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger?) {
        sceneView = SCNView(frame: frame)
        super.init()
        loadModel()

        // Flutter channel for controls
        if let messenger = messenger {
            let channel = FlutterMethodChannel(name: "usdz_channel", binaryMessenger: messenger)
            channel.setMethodCallHandler { [weak self] (call, result) in
                guard let self = self, let node = self.modelNode else { return }

                switch call.method {
                case "rotateX":
                    node.runAction(SCNAction.rotateBy(x: .pi/12, y: 0, z: 0, duration: 0.2))
                    result(nil)

                case "rotateY":
                    node.runAction(SCNAction.rotateBy(x: 0, y: .pi/12, z: 0, duration: 0.2))
                    result(nil)

                case "rotateZ":
                    node.runAction(SCNAction.rotateBy(x: 0, y: 0, z: .pi/12, duration: 0.2))
                    result(nil)

                case "zoomIn":
                    if let cam = self.sceneView.pointOfView?.camera {
                        cam.orthographicScale *= 0.9
                    }
                    result(nil)

                case "zoomOut":
                    if let cam = self.sceneView.pointOfView?.camera {
                        cam.orthographicScale *= 1.1
                    }
                    result(nil)

                // ✅ Absolute rotation
                case "setRotation":
                    if let args = call.arguments as? [String: Any],
                       let x = args["x"] as? Double,
                       let y = args["y"] as? Double,
                       let z = args["z"] as? Double {
                        let radiansX = Float(x * .pi / 180)
                        let radiansY = Float(y * .pi / 180)
                        let radiansZ = Float(z * .pi / 180)
                        node.eulerAngles = SCNVector3(radiansX, radiansY, radiansZ)
                        result(nil)
                    } else {
                        result(FlutterError(code: "INVALID_ARGS", message: "Expected {x,y,z}", details: nil))
                    }

                // ✅ Absolute scale
                case "setScale":
                    if let args = call.arguments as? [String: Any],
                       let scale = args["scale"] as? Double {
                        node.scale = SCNVector3(Float(scale), Float(scale), Float(scale))
                        result(nil)
                    } else {
                        result(FlutterError(code: "INVALID_ARGS", message: "Expected {scale}", details: nil))
                    }

                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    }

    func view() -> UIView {
        return sceneView
    }

    private func loadModel() {
        guard let modelScene = try? SCNScene(named: "Assets.scnassets/model.usdz") else {
            print("❌ Could not load model.usdz")
            return
        }

        if let node = modelScene.rootNode.childNodes.first {
            modelNode = node
        } else {
            modelNode = modelScene.rootNode
        }

        sceneView.scene = modelScene
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = UIColor.clear
        sceneView.isOpaque = false
        sceneView.allowsCameraControl = false

        if let modelNode = modelNode {
            // Reset scale
            modelNode.scale = SCNVector3(1, 1, 1)

            // Bounding box size
            let (minVec, maxVec) = modelNode.boundingBox
            let size = SCNVector3(
                maxVec.x - minVec.x,
                maxVec.y - minVec.y,
                maxVec.z - minVec.z
            )
            let maxDimension = max(size.x, max(size.y, size.z))

            // Normalize model size (largest side = 2 units)
            let targetSize: Float = 2.0
            let scaleFactor = targetSize / maxDimension
            modelNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)

            // Center model at origin
            let center = SCNVector3(
                (minVec.x + maxVec.x) / 2,
                (minVec.y + maxVec.y) / 2,
                (minVec.z + maxVec.z) / 2
            )
            modelNode.position = SCNVector3(-center.x * scaleFactor,
                                            -center.y * scaleFactor,
                                            -center.z * scaleFactor)

            modelNode.eulerAngles = SCNVector3(0, 0, -Float.pi / 2)
        }

        // Setup orthographic camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)

        if let modelNode = modelNode {
            let (minVec, maxVec) = modelNode.boundingBox
            let height = Double(maxVec.y - minVec.y) * Double(modelNode.scale.y)
            let width = Double(maxVec.x - minVec.x) * Double(modelNode.scale.x)
            cameraNode.camera?.orthographicScale = max(height, width) * 0.6
        }

        modelScene.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode
    }
}

class USDZViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return USDZView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
    }
}
