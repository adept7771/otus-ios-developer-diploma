import UIKit

class SearchConfigurator {
    static func configureModule() -> UIViewController {
        let view = SearchViewController()
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        router.viewController = view

        return view
    }
}
