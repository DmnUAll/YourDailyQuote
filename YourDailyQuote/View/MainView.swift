import UIKit

// MARK: - MainViewDelegate protocol
protocol MainViewDelegate: AnyObject {
    func showInfo()
    func refreshQuote()
}

// MARK: - MainView
final class MainView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: MainViewDelegate?

    lazy var quoteLabel: UILabel = {
        makeLabel(withText: "", alignment: .center, andColor: .ydqRed)
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .ydqRed
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    lazy var authorLabel: UILabel = {
        makeLabel(withText: "", alignment: .right, andColor: .ydqPink)
    }()

    private lazy var infoButton: UIButton = {
        makeButton(withIcon: "info.circle", andAction: #selector(infoButtonTapped))
    }()

    private lazy var refreshButton: UIButton = {
        makeButton(withIcon: "arrow.clockwise", andAction: #selector(refreshButtonTapped))
    }()

    private lazy var buttonStackView: UIStackView = {
        makeStackView(withAxis: .horizontal, spacing: 8, andDistribution: .fillEqually)
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = makeStackView(withAxis: .vertical, spacing: 16)
        stackView.toAutolayout()
        return stackView
    }()

    private lazy var linkTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "This app was made, using zenquotes.io API")
        attributedString.addAttribute(.link, value: "https://zenquotes.io", range: NSRange(location: 25, length: 12))
        let textView = UITextView()
        textView.toAutolayout()
        textView.backgroundColor = .clear
        textView.attributedText = attributedString
        textView.textAlignment = .center
        textView.font = UIFont(name: "American Typewriter Bold", size: 12)
        textView.textColor = .ydqPink
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        toAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
private extension MainView {

    @objc private func infoButtonTapped() {
        delegate?.showInfo()
    }

    @objc private func refreshButtonTapped() {
        delegate?.refreshQuote()
    }

    private func addSubviews() {
        buttonStackView.addArrangedSubview(infoButton)
        buttonStackView.addArrangedSubview(refreshButton)
        mainStackView.addArrangedSubview(quoteLabel)
        mainStackView.addArrangedSubview(activityIndicator)
        mainStackView.addArrangedSubview(authorLabel)
        mainStackView.addArrangedSubview(buttonStackView)
        addSubview(mainStackView)
        addSubview(linkTextView)
    }

    private func setupConstraints() {
        let constraints = [
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            linkTextView.centerXAnchor.constraint(equalTo: centerXAnchor),
            linkTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            linkTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            linkTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            linkTextView.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func makeLabel(withText text: String, alignment: NSTextAlignment, andColor color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "American Typewriter Bold", size: 18)
        label.numberOfLines = 0
        label.textColor = color
        label.textAlignment = alignment
        label.isHidden = true
        label.addShadows()
        return label
    }

    private func makeButton(withIcon iconName: String, andAction action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30), forImageIn: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.tintColor = .ydqGray
        button.addShadows()
        return button
    }

    private func makeStackView(withAxis axis: NSLayoutConstraint.Axis,
                               spacing: CGFloat,
                               alignment: UIStackView.Alignment = .fill,
                               andDistribution distribution: UIStackView.Distribution = .fill
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        return stackView
    }
}
