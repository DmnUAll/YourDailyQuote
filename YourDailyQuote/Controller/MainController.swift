import UIKit

// MARK: - MainController
final class MainController: UIViewController {

    // MARK: - Properties and Initializers
    private var presenter: MainPresenter?
    lazy var mainView: MainView = {
        let view = MainView()
        return view
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ydqCream
        view.addSubview(mainView)
        setupConstraints()
        mainView.delegate = self
        presenter = MainPresenter(viewController: self)
        presenter?.loadQuote()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Helpers
private extension MainController {

    private func setupConstraints() {
        let constraints = [
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func changeUIVisibility() {
        mainView.quoteLabel.isHidden.toggle()
        mainView.authorLabel.isHidden.toggle()
        if mainView.activityIndicator.isAnimating {
            mainView.activityIndicator.stopAnimating()
        } else {
            mainView.activityIndicator.startAnimating()
        }
    }
}

// MARK: - MainViewDelegate
extension MainController: MainViewDelegate {
    func showInfo() {
        presenter?.showInfoAlert()
    }

    func refreshQuote() {
        if UserDefaultsManager.shared.updates < 3 {
            changeUIVisibility()
            presenter?.loadNewQuote()
            UserDefaultsManager.shared.updates += 1
        } else {
            presenter?.showInfoAlert()
        }
    }
}

// MARK: - NetworkManagerDelegate
extension MainController: NetworkManagerDelegate {
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mainView.quoteLabel.text = UserDefaultsManager.shared.quote
            self.mainView.authorLabel.text = UserDefaultsManager.shared.author
            self.changeUIVisibility()
        }
    }
}
