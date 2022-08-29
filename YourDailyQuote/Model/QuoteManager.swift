//
//  QuoteManager.swift
//  YourDailyQuote
//
//  Created by Илья Валито on 29.08.2022.
//

import Foundation

protocol QuoteManagerDelegate {
    func updateUI()
}

struct QuoteManager {
    static var delegate: QuoteManagerDelegate?
    static let quoteURL = "https://programming-quotes-api.herokuapp.com/quotes/random"
    
    static func performRequest() {
        if let url = URL(string: quoteURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
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
    
    static func parseJSON(quoteData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(QuoteData.self, from: quoteData)
            AppLogic.quote = decodedData.en
            AppLogic.author = decodedData.author
            //print(AppLogic.quote, AppLogic.author)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.delegate?.updateUI()
    }
}
