import UIKit

class SearchRouter: iSearchRouter {
    weak var viewController: UIViewController?
}

protocol iSearchRouter: AnyObject {
    // Добавьте методы навигации при необходимости
}
