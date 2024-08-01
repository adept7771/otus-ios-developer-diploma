import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let tabBarController = UITabBarController()

        let firstVC = MainViewController()
        firstVC.tabBarItem = UITabBarItem(title: "Local", image: UIImage(systemName: "mappin.and.ellipse.circle.fill"), tag: 0)

        let secondVC = SearchLocationViewController()
        secondVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle.fill"), tag: 1)

        tabBarController.viewControllers = [firstVC, secondVC]

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }
}
