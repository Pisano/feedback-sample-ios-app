import UIKit
import PisanoFeedback

final class FormViewController: UIViewController, UITextFieldDelegate {
    private let backgroundView = BackgroundView()
    private let logoImageView = UIImageView(image: UIImage(named: "PisanoLogo"))
    private let cardView = UIView()

    private let scrollView = UIScrollView()
    private let stack = UIStackView()

    private let nameField = CustomTextField(title: "Name", contentType: .name)
    private let emailField = CustomTextField(title: "Email", placeholder: "email@address.com", keyboard: .emailAddress, contentType: .emailAddress)
    private let phoneField = CustomTextField(title: "Phone", placeholder: "01234567890", keyboard: .phonePad, contentType: .telephoneNumber)
    private let externalIdField = CustomTextField(title: "External Id", contentType: .username)
    private let titleField = CustomTextField(title: "Custom Title", contentType: nil)

    private let modeControl = UISegmentedControl(items: ["Default", "BottomSheet"])
    private let fontControl = UISegmentedControl(items: ["Title", "Body"])

    private let statusLabel = UILabel()

    private let colorScrollView = UIScrollView()
    private let colorStack = UIStackView()
    private var colorButtons: [UIButton] = []
    private var selectedTitleColorIndex: Int = 0

    private var titleColors: [UIColor] {
        let base: [UIColor] = [
            .label,
            .systemBlue,
            .systemGreen,
            .systemYellow,
            UIColor(named: "DarkGray") ?? .darkGray,
            UIColor(named: "Gray") ?? .lightGray,
            .systemGray,
            .systemOrange,
            .systemPink,
            .systemPurple,
            .systemRed,
        ]
        let splash = (0..<6).map { UIColor(named: "Color-\($0)") ?? .systemBackground }
        return base + splash
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupUI()
    }

    private func setupUI() {
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
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            logoImageView.heightAnchor.constraint(equalToConstant: 72),
            logoImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.6),
        ])

        // Allow dismissing keyboard by scrolling
        scrollView.keyboardDismissMode = .onDrag

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 20
        view.addSubview(cardView)
        cardView.addSubview(scrollView)

        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            scrollView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: cardView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
        ])

        // Dismiss keyboard on background tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        stack.addArrangedSubview(nameField)
        stack.addArrangedSubview(emailField)
        stack.addArrangedSubview(phoneField)
        stack.addArrangedSubview(externalIdField)
        stack.addArrangedSubview(titleField)

        // Return key navigation / dismissal
        nameField.textField.returnKeyType = .next
        emailField.textField.returnKeyType = .next
        phoneField.textField.returnKeyType = .done // won't show on phonePad, but harmless
        externalIdField.textField.returnKeyType = .next
        titleField.textField.returnKeyType = .done

        [nameField, emailField, phoneField, externalIdField, titleField].forEach { f in
            f.textField.delegate = self
        }

        // Add Done toolbar for number pad (phone)
        phoneField.textField.inputAccessoryView = makeDoneToolbar()

        addLabeledControl("View Mode", control: modeControl)
        modeControl.selectedSegmentIndex = 0

        addTitleColorPicker()

        addLabeledControl("Title Font", control: fontControl)
        fontControl.selectedSegmentIndex = 0

        stack.addArrangedSubview(AppButton(titleKey: "get_feedback", onTap: { [weak self] in
            self?.didTapShow()
        }))

        stack.addArrangedSubview(AppButton(titleKey: "clear", backgroundColor: .clear, onTap: { [weak self] in
            self?.didTapClear()
        }))

        statusLabel.numberOfLines = 0
        statusLabel.textColor = .secondaryLabel
        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.text = "Status: -"
        stack.addArrangedSubview(statusLabel)
    }

    @objc private func endEditingTap() {
        view.endEditing(true)
    }

    private func makeDoneToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditingTap))
        toolbar.items = [flex, done]
        return toolbar
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField.textField:
            emailField.textField.becomeFirstResponder()
        case emailField.textField:
            phoneField.textField.becomeFirstResponder()
        case phoneField.textField:
            externalIdField.textField.becomeFirstResponder()
        case externalIdField.textField:
            titleField.textField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }

    private func addLabeledControl(_ title: String, control: UISegmentedControl) {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        stack.addArrangedSubview(label)

        stack.addArrangedSubview(control)
    }

    private func addTitleColorPicker() {
        let label = UILabel()
        label.text = "Custom Title Color"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        stack.addArrangedSubview(label)

        colorScrollView.showsHorizontalScrollIndicator = false
        colorScrollView.translatesAutoresizingMaskIntoConstraints = false

        colorStack.axis = .horizontal
        colorStack.spacing = 10
        colorStack.translatesAutoresizingMaskIntoConstraints = false
        colorScrollView.addSubview(colorStack)

        NSLayoutConstraint.activate([
            colorStack.leadingAnchor.constraint(equalTo: colorScrollView.contentLayoutGuide.leadingAnchor),
            colorStack.trailingAnchor.constraint(equalTo: colorScrollView.contentLayoutGuide.trailingAnchor),
            colorStack.topAnchor.constraint(equalTo: colorScrollView.contentLayoutGuide.topAnchor),
            colorStack.bottomAnchor.constraint(equalTo: colorScrollView.contentLayoutGuide.bottomAnchor),
            colorStack.heightAnchor.constraint(equalTo: colorScrollView.frameLayoutGuide.heightAnchor),
        ])

        colorButtons = titleColors.enumerated().map { idx, color in
            let b = UIButton(type: .system)
            b.tag = idx
            b.backgroundColor = color
            b.layer.cornerRadius = 8
            b.clipsToBounds = true
            b.translatesAutoresizingMaskIntoConstraints = false
            b.widthAnchor.constraint(equalToConstant: 40).isActive = true
            b.heightAnchor.constraint(equalToConstant: 50).isActive = true
            b.addTarget(self, action: #selector(didTapColor(_:)), for: .touchUpInside)

            let check = UIImageView(image: UIImage(systemName: "checkmark"))
            check.tintColor = .white
            check.translatesAutoresizingMaskIntoConstraints = false
            check.tag = 999
            b.addSubview(check)
            NSLayoutConstraint.activate([
                check.centerXAnchor.constraint(equalTo: b.centerXAnchor),
                check.centerYAnchor.constraint(equalTo: b.centerYAnchor),
            ])

            colorStack.addArrangedSubview(b)
            return b
        }

        colorScrollView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stack.addArrangedSubview(colorScrollView)

        selectedTitleColorIndex = 0
        refreshColorSelection()
    }

    @objc private func didTapColor(_ sender: UIButton) {
        selectedTitleColorIndex = sender.tag
        refreshColorSelection()
    }

    private func refreshColorSelection() {
        for b in colorButtons {
            let selected = b.tag == selectedTitleColorIndex
            b.alpha = selected ? 0.25 : 1.0
            b.layer.borderWidth = selected ? 2 : 0
            b.layer.borderColor = selected ? UIColor.systemBlue.cgColor : nil
            if let check = b.viewWithTag(999) as? UIImageView {
                check.isHidden = !selected
            }
        }
    }

    private func selectedMode() -> ViewMode {
        modeControl.selectedSegmentIndex == 1 ? .bottomSheet : .default
    }

    private func selectedTitleAttributes() -> NSAttributedString? {
        let t = (titleField.textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return nil }

        let color: UIColor = titleColors[min(max(0, selectedTitleColorIndex), titleColors.count - 1)]

        let font: UIFont = {
            switch fontControl.selectedSegmentIndex {
            case 1: return .preferredFont(forTextStyle: .body)
            default: return .preferredFont(forTextStyle: .title2)
            }
        }()

        return NSAttributedString(string: t, attributes: [.foregroundColor: color, .font: font])
    }

    private func didTapShow() {
        guard PisanoSDKConfig.isValid else {
            statusLabel.text = "Status: missing config (set Info.plist keys or PisanoSecrets.plist)"
            return
        }

        statusLabel.text = "Status: healthCheck..."
        let language = PisanoSDKConfig.language.isEmpty ? nil : PisanoSDKConfig.language
        Pisano.healthCheck(language: language) { [weak self] ok in
            DispatchQueue.main.async {
                guard let self else { return }
                if !ok {
                    self.statusLabel.text = "Status: healthCheck failed (check network/urls)"
                    let alert = UIAlertController(title: "Health Check Failed",
                                                  message: "SDK could not reach the API. Check your network and API URLs.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    return
                }

                self.performShow()
            }
        }
    }

    private func performShow() {
        var customer: [String: Any] = [:]
        customer.addIfNotEmpty(key: "email", value: emailField.textField.text)
        customer.addIfNotEmpty(key: "name", value: nameField.textField.text)
        customer.addIfNotEmpty(key: "phoneNumber", value: phoneField.textField.text)
        customer.addIfNotEmpty(key: "externalId", value: externalIdField.textField.text)

        let language = PisanoSDKConfig.language.isEmpty ? nil : PisanoSDKConfig.language
        FeedbackManager.shared.showFlow(
            mode: selectedMode(),
            title: selectedTitleAttributes(),
            language: language,
            customer: customer.isEmpty ? nil : customer
        ) { [weak self] status in
            DispatchQueue.main.async {
                self?.statusLabel.text = "Status: \(status.description)"
            }
        }
    }

    private func didTapClear() {
        Pisano.clear()
        statusLabel.text = "Status: cleared"
    }
}


