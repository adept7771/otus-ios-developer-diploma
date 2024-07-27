import Foundation
import UIKit

protocol iMainInteractor: AnyObject {
    func fetchBackgroundColor() -> UIColor
}

class MainInteractor: iMainInteractor {
    func fetchBackgroundColor() -> UIColor {
        return .orange
    }
}
