import SwiftUI

extension View {
    @ViewBuilder func placeholder(enabled: Bool) -> some View {
        if #available(iOS 14, *) {
            if enabled {
                self.redacted(reason: .placeholder)
            } else {
                self
            }
        } else {
            self
        }
    }
    
    @ViewBuilder func hide(_ hide: Bool) -> some View {
        if hide {
            self.hidden()
        } else {
            self
        }
    }
}
