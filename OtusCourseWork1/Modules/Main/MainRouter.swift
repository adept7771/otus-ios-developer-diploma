import UIKit

protocol iMainRouter: AnyObject {
    // Добавьте методы навигации при необходимости
}

class MainRouter: iMainRouter {
    weak var viewController: UIViewController?
}
