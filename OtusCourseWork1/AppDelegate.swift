import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ViewController() // Убедитесь, что этот конструктор вызывается правильно.
        window?.rootViewController = viewController
        window?.backgroundColor = .orange // Убедитесь, что у окна установлен цвет фона.
        window?.makeKeyAndVisible()

        return true
    }
}
