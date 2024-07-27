import UIKit

class MainConfigurator {
    
    static func configureModule() -> UIViewController {
        let view = MainViewController()
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        router.viewController = view

        return view
    }
}
