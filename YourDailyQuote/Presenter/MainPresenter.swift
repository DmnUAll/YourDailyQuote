import UIKit

// MARK: - MainPresenter
final class MainPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: MainController?
    private var networkManager = NetworkManager()

    init(viewController: MainController? = nil) {
        self.viewController = viewController
        networkManager.delegate = viewController
    }
}

// MARK: - Helpers
extension MainPresenter {

    func loadQuote() {
        UserDefaultsManager.shared.loadUserDefaults(withNetworkManager: networkManager)
    }

    func showInfoAlert() {
        let message = """
        You can update the quote 3 times per day.
        \(UserDefaultsManager.shared.updates)/3 updates did for today.
        """
        let alertController = UIAlertController(title: "Info",
                                                message: message,
                                                preferredStyle: .alert)
        let gotItAction = UIAlertAction(title: "Got it!", style: .default, handler: nil)
        alertController.addAction(gotItAction)
        viewController?.show(alertController, sender: nil)
    }

    func loadNewQuote() {
        networkManager.performRequest()
    }
}
