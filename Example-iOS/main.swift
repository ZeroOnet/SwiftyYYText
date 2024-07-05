import UIKit

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(AppDelegate.self)
)

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let navigationScene = storyboard.instantiateViewController(withIdentifier: "Navigation")
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationScene
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
