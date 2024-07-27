import Foundation

protocol iMainPresenter: AnyObject {
    func viewDidLoad()
}

class MainPresenter: iMainPresenter {
    weak var view: iMainViewController?
    var interactor: iMainInteractor?

    func viewDidLoad() {
        let color = interactor?.fetchBackgroundColor() ?? .orange
        view?.updateBackgroundColor(to: color)
    }
}
