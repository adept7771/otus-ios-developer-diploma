import Foundation
import UIKit

protocol iSearchInteractor: AnyObject {
    func fetchBackgroundColor() -> UIColor
}

class SearchInteractor: iSearchInteractor {
    func fetchBackgroundColor() -> UIColor {
        return .purple
    }
}
