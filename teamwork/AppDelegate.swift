
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor("#ffffff")
        navigationBarAppearace.barTintColor = UIColor("#456DB2")
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }

}

