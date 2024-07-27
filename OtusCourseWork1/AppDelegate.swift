import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = configureTabBarController()
        window?.makeKeyAndVisible()
        return true
    }

    private func configureTabBarController() -> UITabBarController {
        let mainViewController = MainConfigurator.configureModule()
        let secondViewController = SearchConfigurator.configureModule()

        mainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mainViewController, secondViewController]

        return tabBarController
    }
}
