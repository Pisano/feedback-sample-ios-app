import UIKit

final class AppButton: UIButton {
    private var onTap: (() -> Void)?

    convenience init(titleKey: String, backgroundColor: UIColor? = nil, onTap: (() -> Void)? = nil) {
        self.init(type: .system)

        self.onTap = onTap

        let title = NSLocalizedString(titleKey, comment: "")
        setTitle(title, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 17)

        layer.cornerRadius = 10
        clipsToBounds = true

        let bg = backgroundColor ?? .systemBlue
        self.backgroundColor = bg
        setTitleColor(bg == .clear ? .label : .white, for: .normal)

        heightAnchor.constraint(equalToConstant: 44).isActive = true
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @objc private func didTap() {
        onTap?()
    }
}


