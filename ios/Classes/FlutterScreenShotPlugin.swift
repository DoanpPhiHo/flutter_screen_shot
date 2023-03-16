import Flutter
import UIKit

public class FlutterScreenShotPlugin: NSObject, FlutterPlugin {
    var controller: FlutterViewController?
    
    init(controller: FlutterViewController?) {
        self.controller = controller
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_screen_shot", binaryMessenger: registrar.messenger())
        
        let app = UIApplication.shared
        
        let controller = app.delegate?.window??.rootViewController as? FlutterViewController
        
        let instance = FlutterScreenShotPlugin(controller: controller)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method{
        case "takeScreenShot":takeScreenShot(result: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    private func takeScreenShot(result: @escaping FlutterResult){
        let scale:CGFloat = UIScreen.main.scale
        
        guard let ctl = controller else{
            result(nil)
            return
        }
        UIGraphicsBeginImageContextWithOptions(ctl.view.bounds.size, ctl.view.isOpaque, scale)
        ctl.view.drawHierarchy(in: ctl.view.bounds, afterScreenUpdates: true)
        let optionalImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = optionalImage else{
            result(nil)
            return
        }
        
        guard let data = image.pngData() else{
            result(nil)
            return
        }
        let dataUint8 = [UInt8](data)
        result(dataUint8.map{Int($0) & 255})
    }
}
