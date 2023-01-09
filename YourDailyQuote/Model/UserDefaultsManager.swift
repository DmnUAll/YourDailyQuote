import Foundation

// MARK: - UserDefaultsManager
struct UserDefaultsManager {

    static var shared = UserDefaultsManager()
    var quote: String?
    var author: String?
    var updates: Int = 0
    private var date: Date?

    private func canUserRefreshQuotes() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let date = date else { return true }
        return dateFormatter.string(from: date) != dateFormatter.string(from: Date())
    }

    func saveUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(quote, forKey: "quote")
        defaults.set(author, forKey: "author")
        defaults.set(updates, forKey: "updates")
        defaults.set(date, forKey: "date")
    }

    mutating func loadUserDefaults(withNetworkManager networkManager: NetworkManager) {
        let defaults = UserDefaults.standard
        quote = defaults.string(forKey: "quote")
        author = defaults.string(forKey: "author")
        updates = defaults.integer(forKey: "updates")
        date = defaults.object(forKey: "date") as? Date
        if quote == nil || canUserRefreshQuotes() {
            networkManager.performRequest()
            updates = 0
            date = Date()
        } else {
            networkManager.delegate?.updateUI()
        }
    }
}
