//
//  AppLogic.swift
//  YourDailyQuote
//
//  Created by Илья Валито on 29.08.2022.
//

import Foundation
import UIKit

struct AppLogic {
    private let quoteManager = QuoteManager()
    static var quote: String?
    static var author: String?
    static var updates: Int = 0
    static var date: Date?
    
    static func checkDate() -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let date = date else { return true }
        return dateFormatter.string(from: date) != dateFormatter.string(from: Date())
    }
    
    static func saveUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(quote, forKey: "quote")
        defaults.set(author, forKey: "author")
        defaults.set(updates, forKey: "updates")
        defaults.set(date, forKey: "date")
    }
    
    static func loadUserDefaults() {
        let defaults = UserDefaults.standard
        quote = defaults.string(forKey: "quote")
        author = defaults.string(forKey: "author")
        updates = defaults.integer(forKey: "updates")
        date = defaults.object(forKey: "date") as? Date
        QuoteManager.delegate?.updateUI()
        if quote == nil || checkDate() {
            QuoteManager.performRequest()
            updates = 0
            date = Date()
        }
        //print(quote, author, updates, date)
    }
}
