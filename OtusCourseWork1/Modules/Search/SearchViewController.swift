import UIKit

class SearchViewController: UIViewController {
    var presenter: iSearchPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

protocol iSearchViewController: AnyObject {
    func updateBackgroundColor(to color: UIColor)
}

extension SearchViewController: iSearchViewController {
    func updateBackgroundColor(to color: UIColor) {
        view.backgroundColor = color
    }
}
