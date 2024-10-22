import Flutter

class FlutterEngineManager {
    static let shared = FlutterEngineManager()
    
    private let flutterEngine: FlutterEngine
    private var currentFlutterViewController: FlutterViewController?
    
    private init() {
        self.flutterEngine = FlutterEngine(name: "my flutter engine")
        self.flutterEngine.run()
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
    }
    
    func getFlutterViewController() -> FlutterViewController {
        if let existingController = currentFlutterViewController {
            return existingController
        }
        
        let newController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        currentFlutterViewController = newController
        return newController
    }
    
    func detachCurrentFlutterViewController() {
        flutterEngine.viewController = nil
        currentFlutterViewController = nil
    }
}
