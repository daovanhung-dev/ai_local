import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "LocalAiDeviceStats")
    let channel = FlutterMethodChannel(
      name: "com.localai.chatbot/device",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      let fileSystem = FileManager.default
      let fileSystemAttributes = try? fileSystem.attributesOfFileSystem(forPath: NSHomeDirectory())
      let availableBytes = (fileSystemAttributes?[.systemFreeSize] as? NSNumber)?.int64Value ?? 0
      let thermal: String
      switch ProcessInfo.processInfo.thermalState {
      case .nominal: thermal = "normal"
      case .fair: thermal = "fair"
      case .serious: thermal = "serious"
      case .critical: thermal = "critical"
      @unknown default: thermal = "unknown"
      }
      switch call.method {
      case "deviceStats":
        result([
          "totalMemoryBytes": Int64(ProcessInfo.processInfo.physicalMemory),
          "availableStorageBytes": availableBytes,
          "thermalState": thermal,
        ])
      case "availableStorageBytes":
        result(availableBytes)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
