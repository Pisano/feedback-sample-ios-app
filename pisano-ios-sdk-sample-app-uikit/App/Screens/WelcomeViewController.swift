import UIKit

final class WelcomeViewController: UIViewController {
    private let backgroundView = BackgroundView()
    private let logoImageView = UIImageView(image: UIImage(named: "PisanoLogo"))
    private let cardView = UIView()

    private var logoCenterY: NSLayoutConstraint?
    private var logoTop: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        // Start like SwiftUI: logo centered, then animate to top.
        logoCenterY = logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -40)
        logoTop = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        logoCenterY?.isActive = true

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 72),
            logoImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.6),
        ])

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        let h1 = UILabel()
        h1.text = "Feedback"
        h1.font = .systemFont(ofSize: 28, weight: .bold)

        let h2 = UILabel()
        h2.text = "forms \\ flows"
        h2.font = .systemFont(ofSize: 34, weight: .bold)
        h2.textColor = .systemBlue

        let h3 = UILabel()
        h3.text = "for business"
        h3.font = .systemFont(ofSize: 28, weight: .bold)

        let desc = UILabel()
        desc.text = "Interact with flows made by Pisano"
        desc.font = .systemFont(ofSize: 14, weight: .light)
        desc.textColor = .secondaryLabel
        desc.numberOfLines = 0

        let start = AppButton(titleKey: "getting_started", onTap: { [weak self] in
            self?.goToForm()
        })

        stack.addArrangedSubview(h1)
        stack.setCustomSpacing(2, after: h1)
        stack.addArrangedSubview(h2)
        stack.setCustomSpacing(2, after: h2)
        stack.addArrangedSubview(h3)
        stack.setCustomSpacing(16, after: h3)
        stack.addArrangedSubview(start)
        stack.setCustomSpacing(16, after: start)
        stack.addArrangedSubview(desc)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 20
        cardView.alpha = 0
        cardView.addSubview(stack)

        view.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            cardView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Animate to match SwiftUI's transition-y feel.
        logoCenterY?.isActive = false
        logoTop?.isActive = true

        UIView.animate(withDuration: 0.35, delay: 0.05, options: [.curveEaseInOut]) {
            self.view.layoutIfNeeded()
        }

        UIView.animate(withDuration: 0.25, delay: 0.15, options: [.curveEaseIn]) {
            self.cardView.alpha = 1
        }
    }

    private func goToForm() {
        navigationController?.pushViewController(FormViewController(), animated: true)
    }
}


