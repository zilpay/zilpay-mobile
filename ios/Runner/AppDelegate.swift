import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    LedgerBlePlugin.register(with: self.registrar(forPlugin: "LedgerBlePlugin")!)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
