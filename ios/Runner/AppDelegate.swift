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
        GMSServices.provideAPIKey("AIzaSyBcc8PHB3VnJrZH0_Mqdckf4mhUbYbCNq0")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
