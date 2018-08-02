
import UIKit

extension UIRefreshControl {
    
    convenience init(withMessage message:String, target: Any?, action:Selector) {
        self.init()
        attributedTitle = NSAttributedString(string: message)
        addTarget(target, action: action, for: .valueChanged)
    }
}
