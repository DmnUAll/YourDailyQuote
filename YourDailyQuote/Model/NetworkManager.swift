import Foundation

// MARK: - NetworkManagerDelegate protocol
protocol NetworkManagerDelegate: AnyObject {
    func updateUI()
}

// MARK: - NetworkManager
struct NetworkManager {

    var delegate: NetworkManagerDelegate?
    private let quoteURL = "https://zenquotes.io/?api=random"

    func performRequest() {
        if let url = URL(string: quoteURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let safeData = data {
                    self.parseJSON(quoteData: safeData)
                }
            }
            task.resume()
        }
    }

    private func parseJSON(quoteData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(QuoteModel.self, from: quoteData)
            UserDefaultsManager.shared.quote = decodedData[0].q
            UserDefaultsManager.shared.author = decodedData[0].a
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.delegate?.updateUI()
    }
}
