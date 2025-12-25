import UIKit

final class BackgroundView: UIView {
    private var timer: Timer?
    private var currentIndex: Int = 0

    private var splashColors: [UIColor] {
        (0..<6).map { idx in
            UIColor(named: "Color-\(idx)") ?? .systemBackground
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = splashColors.first ?? .systemBackground

        // Match SwiftUI sample: rotate splash colors every 1s.
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        timer?.invalidate()
    }

    private func tick() {
        let colors = splashColors
        guard !colors.isEmpty else { return }
        currentIndex = (currentIndex + 1) % colors.count

        UIView.transition(with: self, duration: 0.35, options: [.transitionCrossDissolve, .allowUserInteraction]) {
            self.backgroundColor = colors[self.currentIndex]
        }
    }
}


