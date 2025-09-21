import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    
    // Register USDZView plugin
    if let registrar = controller.registrar(forPlugin: "USDZView") {
        registrar.register(
            USDZViewFactory(messenger: registrar.messenger()),
            withId: "USDZView"
        )
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
