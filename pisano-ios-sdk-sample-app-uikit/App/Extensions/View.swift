import UIKit

extension UIView {
    /// UIKit equivalent of SwiftUI's `hide(_:)` helper.
    func hide(_ hide: Bool) {
        isHidden = hide
    }

    /// Very lightweight placeholder effect (kept for parity with the SwiftUI sample).
    func placeholder(enabled: Bool) {
        alpha = enabled ? 0.5 : 1.0
    }
}


