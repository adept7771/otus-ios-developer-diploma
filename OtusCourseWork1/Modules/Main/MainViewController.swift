import UIKit

protocol iMainViewController: AnyObject {
    func updateBackgroundColor(to color: UIColor)
}

class MainViewController: UIViewController {
    var presenter: iMainPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

extension MainViewController: iMainViewController {
    func updateBackgroundColor(to color: UIColor) {
        view.backgroundColor = color
    }
}
