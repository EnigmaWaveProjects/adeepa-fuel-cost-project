import UIKit
import Flutter
import GoogleMaps  // Import the GoogleMaps module

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        GMSServices.provideAPIKey("AIzaSyCB8e-gKhk2zsZnSbKIWHgV8kF5wVeRX3g")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
