import UIKit

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(Dummy.self)
)

class Dummy: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let home = storyboard.instantiateViewController(withIdentifier: "Home")
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = home
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
