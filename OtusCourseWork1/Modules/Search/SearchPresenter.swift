import Foundation

class SearchPresenter: iSearchPresenter {
    
    weak var view: iSearchViewController?
    var interactor: iSearchInteractor?
    
    func viewDidLoad() {
        let color = interactor?.fetchBackgroundColor() ?? .purple
        view?.updateBackgroundColor(to: color)
    }
}

protocol iSearchPresenter: AnyObject {
    func viewDidLoad()
}
